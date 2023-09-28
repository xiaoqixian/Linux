# Date: Sat Sep 09 18:21:57 2023
# Mail: lunar_ubuntu@qq.com
# Author: https://github.com/xiaoqixian

error() {
    echo -e "\033[1;31m[Error] $@\033[0m"
}
debug() {
    echo -e "\033[0;32m[Debug] $@\033[0m"
}
warn() {
    echo -e "\033[1;35m[Warn] $@\033[0m"
}

# globals
no_chapter_seq=0
toc_order=1
zip_book=0
readonly volume_pattern='第[零一二两三四五六七八九十百千万0-9\.]\{1,4\}卷'
readonly chapter_pattern='第[零一二两三四五六七八九十百千万0-9]\{1,7\}章'

# chapter sequence number
# modified only by add_chapter function
chapter_seq=1
volume_seq=1
chapter_count=1
volume_count=1

total_volumes=0
total_chapters=0

min_chapter_length=50

declare -A -r zh_nums=(
    ["1"]="一"
    ["2"]="二"
    ["3"]="三"
    ["4"]="四"
    ["5"]="五"
    ["6"]="六"
    ["7"]="七"
    ["8"]="八"
    ["9"]="九"
)

declare -A -r units=(
    ["0"]=""
    ["1"]="十"
    ["2"]="百"
    ["3"]="千"
    ["4"]="万"
)

check_chapters() {
    if [[ "$extra_chapter_match" ]]; then
        gsed -n -e "s/^\s*\(${chapter_pattern}.*\)/\1/p" -e "s/\(${extra_chapter_match}\)/\1/p" "$1"
    else 
        cat -n "$1" | gsed -n -e "s/^\s*\([0-9]\+\)\s*\(${chapter_pattern}.*\)/\1 \2/p"
    fi

    local chapter_ln=( $(gsed -n -e "/^\s*${chapter_pattern}/=" "$1") )
    local total_lines=${#chapter_ln[@]}
    chapter_ln+=( $(wc -l "$1" | gsed -n "s/ *\([0-9]*\).*/\1/p") )
    local i=0
    while [[ $i -lt $total_lines ]]; do
        local a=${chapter_ln[$i]}
        let i++
        local b=${chapter_ln[$i]}
        local diff=`expr $b - $a`
        if [[ $diff -lt $min_chapter_length ]]; then
            warn "Bad chapter $a $(gsed -n -e "$a p" "$1") [$diff]"
        fi
    done
}
check_volumes() {
    if [[ "$extra_volume_match" ]]; then
        gsed -n -e "s/^\s*\(${volume_pattern}.*\)/\1/p" -e "s/\(${extra_volume_match}\)/\1/p" "$1"
    else 
        cat -n "$1" | gsed -n -e "s/^\s*\([0-9]\+\)\s*\(${volume_pattern}.*\)/\1 \2/p"
    fi
}

compare_chapters() {
    local website="https://www.69shuba.com/book/$2/"
    local website_match=( $(gsed -n -e '/^\s*<li data-num=.*/=' temp) )
    local txt_match=( $(gsed -n -e "/^\s*${chapter_pattern}/=" "$1") )
    
    local a=${#website_match[@]}
    local b=${#txt_match[@]}

    if [[ $a -ge $b ]]; then
        local loop=$b
    else local loop=$a
    fi

    for i in $(seq 0 `expr $loop - 1`); do
        echo -e "$(gsed -n -e "${txt_match[$i]} p" "$1")\t $(gsed -n -e "${website_match[$i]} s/^\s*<li data-num=.*>\(.*\)<\/a>.*/\1/p" temp)"
    done
}

check_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            -a) author="$2"; shift 2;;
            -i) input="$2"; shift 2;;
            -o) out="$2"; shift 2;;
            -s) cover="$2"; shift 2;;
            -c) slim="$2"; shift 2;;
            -l) lang="$2"; shift 2;;
            -z) zip_book=1; shift;;
            --no-chapter-seq) no_chapter_seq=1; shift;;
            --extra-volume-match) extra_volume_match="$2"; shift 2;;
            --extra-chapter-match) extra_chapter_match="$2"; shift 2;;
            --min-chapter-length) min_chapter_length="$2"; shift 2;;
            --compare-chapters) compare_chapters "$2" "$3"; exit 0;;
            --check-chapters) check_chapters "$2"; exit 0;;
            --check-volumes) check_volumes "$2"; exit 0;;
            *) error "Unknow option '$1'";
                return 1;;
        esac
    done

    if [ -z "$input" ]; then
        error "input file needed"
        return 1
    elif [ ! -f "$input" ]; then
        error "input '$input' is not a file"
        return 1
    elif [ "${input##*.}" != "txt" ]; then
        error "input '$input' is not a txt file"
        return 1
    fi

    if [ -z "$out" ]; then
        filename=$(basename "$input")
        out="${filename%.*}"
    fi

    if [ -f "$out.epub" -o -d "$out.epub" ]; then
        error "Output file '$out.epub' exists"
        echo -n "Remove '$out.epub'? [y/n]:"
        read ans
        if [[ $ans = "y" || $ans = "Y" ]]; then
            rm -rf "$out.epub"
        else return 1
        fi
    fi

    if [ ! -z "$cover" ]; then
        cover_ext="${cover##*.}"
    fi
}

num_to_zh() {
    if ! [[ $1 =~ ^[0-9]+$ ]]; then
        echo "Invalid number '$1'" >&2
        return 1
    fi
    num="$1"
    res=""
    zero_flag=0
    unit_index=0
    
    while [ $num -gt 0 ]; do
        let digit=num%10
        if [ $digit -eq 0 ]; then
            if [[ ! -z $res && $zero_flag -eq 0 ]]; then
                res="零${res}"
            fi
            zero_flag=1
        else 
            res="${zh_nums[$digit]}${units[$unit_index]}${res}"
            zero_flag=0
        fi
        let unit_index++
        let num/=10
    done

    if [[ ${#res} -ge 2 && ${res:0:2} = "一十" ]]; then
        res=${res:1}
    fi

    echo "$res"
}

init() {
    mkdir "$out.epub"
    mkdir "$out.epub/OPS"
    mkdir "$out.epub/META-INF"
    mkdir "$out.epub/OPS/html"
    mkdir "$out.epub/OPS/css"
    mkdir "$out.epub/OPS/images"

    ncx_file="$out.epub/OPS/toc.ncx"
    opf_file="$out.epub/OPS/content.opf"
    html_dir="$out.epub/OPS/html"

    if [[ -z "$cover" || ! -f "$cover" ]]; then
        cover="$slim"
    else cp "$slim" "$out.epub/iTunesArtwork"
    fi

    # copy cover image to images
    valid_extensions=("jpg" "jpeg" "png" "webp")
    if [[ ! -z "$cover" && -f "$cover" && "${valid_extensions[@]}" =~ $cover_ext ]]; then
        cp "$cover" "$out.epub/OPS/images/cover.${cover_ext}"
    fi

    # create mimetype
    touch "$out.epub/mimetype"
    echo "application/epub+zip" > "$out.epub/mimetype"

    # create container.xml
    touch "$out.epub/META-INF/container.xml"
    echo '<?xml version="1.0" encoding="UTF-8" ?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
   <rootfiles>
      <rootfile full-path="OPS/content.opf" media-type="application/oebps-package+xml"/>
   </rootfiles>
</container>' > "$out.epub/META-INF/container.xml"

    # create stylesheet
    # main.css
    touch "$out.epub/OPS/css/main.css"
    echo 'body {
        padding: 0%;
        margin-top: 0%;
        margin-bottom: 0%;
        margin-left: 1%;
        margin-right: 1%;
        line-height:130%;
        text-align: justify;
    }
    div {
        margin:0px;
        padding:0px;
        line-height:130%;
        text-align: justify;
    }
    p {
        text-align: justify;
        text-indent: 2em;
        line-height:130%;
    }
    .cover {
        width:100%;
        padding:0px;
    }
    .center {
        text-align: center;
        margin-left: 0%;
        margin-right: 0%;
    }
    .left {
        text-align: center;
        margin-left: 0%;
        margin-right: 0%;
    }
    .right {
        text-align: right;
        margin-left: 0%;
        margin-right: 0%;
    }
    .quote {
        margin-top: 0%;
        margin-bottom: 0%;
        margin-left: 1em;
        margin-right: 1em;
        text-align: justify;
    }
    h1 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:xx-large;
    }
    h2 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:x-large;
    }
    h3 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:large;
    }
    h4 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:medium;
    }
    h5 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:small;
    }
    h6 {
        line-height:130%;
        text-align: center;
        font-weight:bold;
        font-size:x-small;
    }
    h1.vol {
        font-size: 1.1em;
        width: 1em;
        margin: 30% auto 1em auto;
        text-align: center;
    }
    p.vol {
        font-size: 1.4em;
        margin: 0 auto;
        text-align: center;
        text-indent: 0em;
        duokan-text-indent: 0em;
        border-left: 1px solid #fff;
        border-right: 1px solid #fff;
        width: 1em;
        padding: 3px 4px;
        font-weight:bold;
    }' > "$out.epub/OPS/css/main.css"
    

    # cover.css
    touch "$out.epub/OPS/css/cover.css"
    echo 'body {
  background-color: #FFFFFF;
  margin-bottom: 0px;
  margin-left: 0px;
  margin-right: 0px;
  margin-top: 0px;
  text-align: center;
}
img {
  max-height: 100%;
  max-width: 100%;
}' > "$out.epub/OPS/css/cover.css"

    # create toc.ncx header
    touch "$ncx_file"
    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<!DOCTYPE ncx PUBLIC \"-//NISO//DTD ncx 2005-1//EN\"
 \"http://www.daisy.org/z3986/2005/ncx-2005-1.dtd\">
<ncx xmlns=\"http://www.daisy.org/z3986/2005/ncx/\" version=\"2005-1\">
  <head>
    <meta name=\"dtb:uid\" content=\"urn:uuid:d0cca237-33a9-409b-acd7-4a5586862c1d\" />
    <meta name=\"dtb:depth\" content=\"2\" />
    <meta name=\"dtb:totalPageCount\" content=\"0\" />
    <meta name=\"dtb:maxPageNumber\" content=\"0\" />
  </head>
  <docTitle>
    <text>${out}</text>
  </docTitle>
  <navMap>
    <navPoint id=\"coverpage\" playOrder=\"0\">
      <navLabel><text>封面</text></navLabel>
      <content src=\"html/coverpage.html\" />
    </navPoint>" > "$ncx_file"

    # create content.opf header
    touch "$opf_file"
    echo "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>
<package xmlns=\"http://www.idpf.org/2007/opf\" unique-identifier=\"duokan-book-id\" version=\"2.0\">
  <metadata xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:opf=\"http://www.idpf.org/2007/opf\">
    <dc:identifier id=\"duokan-book-id\" opf:scheme=\"UUID\">urn:uuid:d0cca237-33a9-409b-acd7-4a5586862c1d</dc:identifier>
    <dc:title>${out}</dc:title>
    <dc:creator opf:role=\"aut\">${author}</dc:creator>
    <dc:language>zh-CN</dc:language>
    <dc:contributor opf:role=\"cre\"></dc:contributor>
    <dc:publisher></dc:publisher>
    <dc:date opf:event=\"modification\">$(date +%Y-%m-%d)</dc:date>
    <meta content=\"0.8.7\" name=\"Sigil version\" />
    <meta name=\"cover\" content=\"cover.${cover_ext}\" />
  </metadata>
  <manifest>
    <item id=\"ncx\" href=\"toc.ncx\" media-type=\"application/x-dtbncx+xml\" />
    <item id=\"coverpage\" href=\"html/coverpage.html\" media-type=\"application/xhtml+xml\" />
    <item id=\"main-css\" href=\"css/main.css\" media-type=\"text/css\" />
    <item id=\"css\" href=\"css/main.css\" media-type=\"text/css\" />
    <item id=\"cover.${cover_ext}\" href=\"images/cover.${cover_ext}\" media-type=\"image/${cover_ext}\" />
  <spine toc=\"ncx\">" > "$opf_file"

    # create coverpage.html
    touch "${html_dir}/coverpage.html"
    echo "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"zh-CN\">
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
<title>bookcover</title>
</head>
<body>
<img class=\"cover\" src=\"../images/cover.${cover_ext}\" alt=\"Cover Image Not Found\"/>
</body>
</html>" > "${html_dir}/coverpage.html"
}

add_volume() {
    if [[ $# -lt 1 ]]; then
        error "add_volume(): insufficient arguments"
        return 1
    fi
    local ln="$1"
    local extra_matched=0

    if [[ "$extra_volume_match" ]]; then
        local temp="$(gsed -n "$ln s/\(${extra_volume_match}\)/\1/p" "${input}")"
        if [[ "$temp" ]]; then
            local volume_name="${temp}"
            local volume_header="  <h1 class=\"vol\" title=\"${temp}\">${temp}</h1>"
            local extra_matched=1
        fi
    fi

    if [[ -z "${volume_header}" ]]; then
        zh_seq="$(num_to_zh "${volume_seq}")"
        let volume_seq++
        local volume_name="$(gsed -n -e "$ln s/^\s*${volume_pattern} *\(\S*\)\s*$/\1/p" "${input}")"
        if [[ -z "$volume_name" ]]; then
            warn "Empty volume name: ${ln} 第${zh_seq}卷"
            local volume_header="  <h1 class=\"vol\" title=\"第${zh_seq}卷\">第${zh_seq}卷</h1>"
        else 
            local volume_header="  <h1 class=\"vol\" title=\"第${zh_seq}卷 ${volume_name}\">第${zh_seq}卷</h1>
    <p class=\"vol\">${volume_name}</p>"
        fi
    fi

    local volume_file="${html_dir}/volume${volume_count}.html"
    touch "${volume_file}"

    echo "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>
<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"zh-CN\">
<head>
  <title></title>
  <link href=\"../css/main.css\" rel=\"stylesheet\" type=\"text/css\" />
</head>
<body class=\"vol\">
${volume_header}
</body>
</html>" > "$volume_file"
    
    # append to ncx_file
    if [[ ${volume_count} -gt 1 ]]; then
        echo "    </navPoint>" >> "${ncx_file}"
    fi

    if [[ $extra_matched -eq 0 ]]; then
        local volume_seq_name="第${zh_seq}卷 ${volume_name}"
    else local volume_seq_name="${volume_name}"
    fi

    echo -e "\033[1;34m${volume_seq_name}\033[0m"

    echo "    <navPoint id=\"volume${volume_count}\" playOrder=\"${toc_order}\">
      <navLabel><text>${volume_seq_name}</text></navLabel>
      <content src=\"html/volume${volume_count}.html\"/>" >> "${ncx_file}"

    let toc_order++
    
    # append to content.opf
    gsed -i -e "/<spine.*>/i \ \ \ \ <item id=\"volume${volume_count}\" href=\"html/volume${volume_count}.html\" media-type=\"application/xhtml+xml\"/>" "$opf_file"
    echo "    <itemref idref=\"volume${volume_count}\"/>" >> "$opf_file"

    let volume_count++
    return 0
}


add_chapter() {
    if [[ $# -lt 3 ]]; then
        error "add_chapter(): insufficient arguments"
        return 1
    fi
    local ln="$1"
    local start="$2"
    local end="$3"
    local extra_matched=0

    if [[ "$extra_chapter_match" ]]; then
        local temp="$(gsed -n "$ln s/\(${extra_chapter_match}\)/\1/p" "${input}")"
        if [[ "$temp" ]]; then
            local chapter_name="$temp"
            local extra_matched=1
        fi
    fi

    if [[ -z "$chapter_name" ]]; then
        zh_seq="$(num_to_zh "${chapter_seq}")"
        let chapter_seq++
        local chapter_name="第${zh_seq}章 $(gsed -n -e "$ln s/^\s*${chapter_pattern}\s*\(\S*\)\s*$/\1/p" "${input}")"
    fi

    local chapter_file="${html_dir}/chapter${chapter_count}.html"

    touch "${chapter_file}"

    echo "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"zh-CN\">
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
<link rel=\"stylesheet\" type=\"text/css\" href=\"../css/main.css\"/>
<title>${chapter_name}</title>
</head>
<body>
<div>
<h3>${chapter_name}</h3>" > "${chapter_file}"

    # match paragraph
    #gsed -n -e "${start},${end} s/^\s*\(\S*\)\s*$/<p>\1<\/p>/p" "$input" >> "${chapter_file}"
    gsed -n -e "${start},${end} s/^[\s  ]*\(.*\)/<p>\1<\/p>/p" "$input" >> "${chapter_file}"

    echo '</div>
</body>
</html>' >> "$chapter_file"

    echo "${chapter_name}"

    # append to toc.ncx
    echo "      <navPoint id=\"chapter${chapter_count}\" playOrder=\"${toc_order}\">
        <navLabel><text>${chapter_name}</text></navLabel>
        <content src=\"html/chapter${chapter_count}.html\"/>
      </navPoint>" >> "$ncx_file"
    let toc_order++

    # append to content.opf
    gsed -i -e "/<spine.*>/i \ \ \ \ <item id=\"chapter${chapter_count}\" href=\"html/chapter${chapter_count}.html\" media-type=\"application/xhtml+xml\"/>" "${opf_file}"
    echo "    <itemref idref=\"chapter${chapter_count}\" linear=\"yes\"/>" >> "${opf_file}"

    let chapter_count++
    return 0
}


collect_volume_chapters() {
    if [[ "${extra_volume_match}" ]]; then
        #local volumes=( $(cat -n "$input" | gsed -n -e "s/\s*\([0-9]\+\)\s*${volume_pattern}.*/\1/p" -e "s/^\s*\([0-9]\+\)\s*\(${extra_volume_match}\)\s*$/\1/p") )
        local volumes=( $(gsed -n -e "/^\s*${volume_pattern}/=" -e "/${extra_volume_match}/=" "${input}") )
    else 
        #local volumes=( $(cat -n "$input" | gsed -n -e "s/\s*\([0-9]\+\)\s*${volume_pattern}.*/\1/p") )
        local volumes=( $(gsed -n -e "/^\s*${volume_pattern}/=" "${input}") )
    fi
    debug ${volumes[@]}
    total_volumes=${#volumes[@]}
    debug "${total_volumes} volume line number collected"
    #local volumes=( $(cat -n "$input" | gsed -n -e "s/\s*\([0-9]\+\)\s*${volume_pattern}.*/\1/p") )
    #debug "${#volumes[@]} volume line number collected"

    if [[ "${extra_chapter_match}" ]]; then
        #local chapters=( $(cat -n "$input" | gsed -n -e "s/\s*\([0-9]\+\)\s*${chapter_pattern}.*/\1/p" -e "s/^\s*\([0-9]\+\)\s*${extra_chapter_match}\s*$/\1/p") )
        local chapters=( $(gsed -n -e "/^\s*${chapter_pattern}/=" -e "/${extra_chapter_match}/=" "${input}") )
    else 
        #local chapters=( $(cat -n "$input" | gsed -n -e "s/\s*\([0-9]\+\)\s*${chapter_pattern}.*/\1/p") )
        local chapters=( $(gsed -n -e "/^\s*${chapter_pattern}/=" "${input}") )
    fi
    total_chapters=${#chapters[@]}
    debug "${total_chapters} chapter line number collected"

    total_lines=$(wc -l "$input" | gsed -n "s/ *\([0-9]*\).*/\1/p")
    volumes+=($total_lines)
    chapters+=($(expr $total_lines + 1))
    
    #volume_seq=1
    #chapter_seq=1
    local volume_index=0

    for i in $(seq 0 $(expr ${#chapters[@]} - 2)); do
        local start=$(expr ${chapters[$i]} + 1)
        local end=$(expr ${chapters[$(expr $i + 1)]} - 1)

        if [[ $start -gt ${volumes[$volume_index]} ]]; then
            add_volume "${volumes[$volume_index]}"
            if [[ $? -eq 1 ]]; then
                error "add_volume error"
                return 1
            fi
            let volume_index++
        fi

        add_chapter "${chapters[$i]}" "$start" "$end"
        if [[ $? -eq 1 ]]; then
            error "Add chapter error"
            return 1
        fi
    done
}

finish() {
    # finish toc.ncx
    if [[ ${total_volumes} -gt 0 ]]; then
        echo '</navPoint>' >> "$ncx_file"
    fi
    echo '</navMap>
</ncx>' >> "$ncx_file"

    # finish content.opf
    gsed -i -e "/<spine.*>/i \ \ </manifest>" "$opf_file"
    echo '  </spine>
  <guide>
    <reference href="html/coverpage.html" title="封面" type="cover" xmlns="http://www.idpf.org/2007/opf" />
  </guide>
</package>' >> "$opf_file"
}

check_args $@
if [ $? -eq 1 ]; then 
    rm -rf "$out.epub"
    exit 1; 
fi
init
if [ $? -eq 1 ]; then 
    rm -rf "$out.epub"
    exit 1; 
fi
collect_volume_chapters
if [ $? -eq 1 ]; then 
    rm -rf "$out.epub"
    exit 1; 
fi
finish

if [[ $zip_book -eq 1 ]]; then
    cd "${out}.epub"
    zip -r "${out}.zip" * > /dev/null
    cd ..
    mv "${out}.epub/${out}.zip" ./
    rm -rf "${out}.epub"
    mv "${out}.zip" "${out}.epub"
fi
