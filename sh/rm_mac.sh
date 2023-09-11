#!/usr/local/Cellar/bash/5.2.15/bin/bash

TRASH_DIR="$HOME/.trash"
LOG_FILE="${TRASH_DIR}/.log"
VERSION="1.0"
NAME="rm"


# trash dir path: $TRASH_DIR
# create dir if not exists
if [ ! -d "$TRASH_DIR" ]
then mkdir -v "$TRASH_DIR"
fi

if [ ! -f "$LOG_FILE" ]
then touch "$LOG_FILE"
fi

error() {
    echo -e "\e[1;31m[ERROR] $@ \e[0m"
}

debug() {
    echo -e "\e[1;32m[DEBUG] $@ \e[0m"
}

echo_red() {
    echo -e "\e[0;31m$@\e[0m"
}
echo_ye() {
    echo -e "\e[0;33m$@\e[0m"
}
echo_blue() {
    echo -e "\e[0;36m$@\e[0m"
}

usage()
{
    echo -e "Usage: delete [options] [file1 file2 file3....]\n"
    echo "delete is a simple command line interface for deleting file to custom trash."
    echo "Options:"
    echo "  -c | --clear    Empty the trash"
    echo "  -f | --force    Force delete file instead of moving into trash"
    echo "  -r | --restore  Restore the file in the trash"
    echo "  -l | --list     List the files in the trash"
    echo "  -p | --print    Print log file"
    echo "  -h | --help     Show this help message and exit"
    echo "  -v | --version  Show program's version number and exit"
    echo "  -t | --trash    Set default trash can path, this option has peermanent effect"
}

version() {
    echo "${NAME} (Trash Collection) 1.0"
}

print_log() {
    cat "${LOG_FILE}"
}

list() {
    ls "${TRASH_DIR}"
}

set_trash() {
    if [[ $# -eq 0 ]]; then
        echo "${NAME}: '-t' option missing trash can path"
        exit 1
    fi
    if [[ $# -gt 1 ]]; then
        echo "Only one trash can path is acceptable"
        exit 1
    fi

    fullpath="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
    if [ -f "${fullpath}" ]; then
        echo "${NAME}: cannot set directory '$1' as trash can: File exists"
        exit 1
    fi

    if [ ! -d "${fullpath}" ]; then
        echo "Target directory doesn't exist"
        echo -ne "Do you want to create this directory? [y/n]: \a"
        read reply

        if [ ! $reply = "y" -o ! $reply = "Y" ]; then
            exit 1
        fi

        mkdir -p "${fullpath}"
        if [ ! $? -eq 0 ]; then
            echo "mkdir ${fullpath} failed"
            exit 1
        fi
    fi

    TRASH_DIR="${fullpath}"
    LOG_FILE="${fullpath}/.log"
    touch "${LOG_FILE}"

    fullpath=${fullpath//\//\\\/} #replace all / with \/ in fullpath
    sed -i "0,/TRASH_DIR/{s/TRASH_DIR=.*/TRASH_DIR=\"${fullpath}\"/}" "$0"
}

clear_trash() {
    echo -ne "Are you sure you want to clear trash? [y/n]:\a"
    read reply

    case $reply in
        'y'|'Y')
            for file in $(ls -A "${TRASH_DIR}"); do
                echo "Removing ${TRASH_DIR}/${file} foreverly."
                rm -rf "$TRASH_DIR/$file"
            done
            echo -ne "Do you want to clear all logs? [y/n]:\a"
            read reply
            if [ $reply = "y" -o $reply = "y" ]; then
                echo "clearing all logs"
                cat /dev/null > "${LOG_FILE}"
            fi
            echo "Done.";;
        'n'|'N') echo "Cancelling deleteing.";;
        *) echo "Unrecognized character.";;
    esac
}

force_delete() {
    if [ $# -eq 0 ]; then
        echo "${NAME}: missing operand"
        exit 0
    fi

    echo -ne "Are you sure you want to foreverly delete file[s]? [y/n]:\a"
    read reply

    case "$reply" in
        'y'|'Y')
            for file in $@; do
                rm -rf "${file}"
            done
            echo "Done.";;
        'n'|'N') echo "Cancelling deleteing.";;
        *) echo "Unrecognized character.";;
    esac
}

delete() {
    for file in $@; do
        debug "deleting ${file}"
        if [ ! -f "$file" -a ! -d "$file" ]
        then
            echo "${NAME}: cannot remove '$file': No such file or directory"
            continue
        fi

        # check if user want to move file larger than 2GB to trash
        if [ -f "$file" -a $(du -k "$file" | cut -f1) -gt 2097152 ]; then
            echo "File '$file' size is larger than 2GB."
            echo -ne "Do you still want to move it to trash? [y/n]: \a"
            read reply

            if [ ! $reply = "y" -a ! $reply = "Y" ]; then
                echo "moving aborted"
                exit 0
            fi
        fi

        filename="$(basename "$file")"
        fullpath="$(cd "$(dirname "$file")"; pwd)/${filename}"
        now="$(date +%a%b%d%H%M%S%Y)"

        if [ -f "$TRASH_DIR/${filename}_${now}" -o -d "$TRASH_DIR/${filename}_${now}" ]; then
            sleep 1
            now="$(date +%a%b%d%H%M%S%Y)"
        fi

        mv $file "$TRASH_DIR/${filename}_${now}"
        debug "new filename ${filename}_${now}"

        if [ ! $? -eq 0 ]; then
            error "mv $file to $TRASH_DIR/${filename} failed\a"
        fi

        echo "${fullpath}_${now}" | sed "s/\(.*\)_\([A-Za-z]\{3\}\)\([A-Za-z]\{3\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{4\}\)/\1 \2 \3 \4 \5:\6:\7 \8/" >> ${LOG_FILE}
        echo "File '${file}' successfully moved in."
        echo "Trash can size: $(du -h -s "${TRASH_DIR}" | cut -f1)"
    done
}

restore() {
    if [ $# -eq 0 ]; then
        echo "${NAME}: restore missing operand"
        exit 1
    fi

    for file in $@; do
        filename="$(basename "$file")"
        fullpath="$(cd "$(dirname "$file")"; pwd)/${filename}"

        if [ $filename = $file ]; then #if only the basename is provided
            debug "match base name $filename"
            grep_pattern=".*/${file} [A-Za-z]\+ [A-Za-z]\+ [0-9]\+ [0-9]\+:[0-9]\+:[0-9]\+ [0-9]\+"
            logs=$(cat "${LOG_FILE}")

            matched_line_nums=()
            line_number=0

            #for line in $logs; do
            while IFS= read -r line; do
                let line_number++
                if [ -z "$(echo "$line" | grep "${grep_pattern}")" ]; then
                    continue
                fi

                matched_line_nums+=($line_number)
            done < "${LOG_FILE}"

            if [ ${#matched_line_nums[@]} -eq 0 ]; then
                echo -e "\e[0;31mNo matching files were found for the target file '${file}'\e[0m"
                continue
            fi
            
            echo -e "\e[0;33mFollowing files were for the target file '${file}':\n\e[0m"

            index=0
            for ln in ${matched_line_nums[@]}; do
                line=( $(sed -n "${ln}p" "${LOG_FILE}") )
                echo -e "\e[0;33m[${index}]\e[0m ${line[0]} \e[0;36m[${line[@]:1}]\e[0m"
                let index++
            done

            echo -ne "\n\e[0;33mEnter the number of your target: \e[0m"
            read reply

            if [ ! $reply -ge 0 -o $reply -ge ${#matched_line_nums[@]} ]; then
                echo_red "restore: reply '${reply}' is out of bounds"
                exit 1
            fi

            file_info=( $(sed -n "${matched_line_nums[$reply]} s/\(.*\)\/${file} \([A-Za-z]*\) \([A-Za-z]*\) \([0-9]*\) \([0-9]*\):\([0-9]*\):\([0-9]*\) \([0-9]*\)/\1 \2 \3 \4 \5 \6 \7 \8/p" "${LOG_FILE}") )
            debug "file_info[${#file_info[@]}]: ${file_info[@]}]"

            if [ ! ${#file_info[@]} -eq 8 ]; then
                error "target line match failed"
                exit 1
            fi

            original_path="${file_info[0]}/${filename}"
            if [ -f "${original_path}" -o -d "${original_path}" ]; then
                echo_red "${NAME}: cannot restore file '${file}': File exists"
                continue
            fi

            trash_file="${filename}_${file_info[@]:1}"
            trash_file="${trash_file//[[:space:]]/}"

            if [ ! -f "${TRASH_DIR}/${trash_file}" -a ! -d "${TRASH_DIR}/${trash_file}" ]; then
                error "${NAME}: trash file '${trash_file}' not found"
                exit 1
            fi

            mv "${TRASH_DIR}/${trash_file}" "${original_path}"
            if [ $? -eq 0 ]; then
                #sed -i "${matched_line_nums[$reply]}d" "${LOG_FILE}"
                sed -i '' "${matched_line_nums[$reply]}d" "${LOG_FILE}"
            else 
                error "mv ${TRASH_DIR}/${trash_file} to ${original_path} failed"
                exit 1
            fi
        fi
    done
}

option="d"
args=()
declare -A -r funcs=(
    ["d"]="delete"
    ["h"]="usage"
    ["v"]="version"
    ["p"]="print_log"
    ["l"]="list"
    ["c"]="clear_trash"
    ["r"]="restore"
    ["t"]="set_trash"
    ["f"]="force_delete"
)

if [[ $# -eq 0 ]]; then
    echo "${NAME}: missing operand"
    echo "Try '${NAME} -h' for more information"
    exit 0
fi

# process arguments
while [[ $# -gt 0 ]]; do
    debug "arg $1"
    debug "args: ${args[@]}"
    case $1 in
        -h | -c | -f | -r | -v | -l | -p | -t | --help | --clear | --force | --restore | --version | --list | --print | --trash)
            debug "calling ${funcs[$option]} ${args[@]}"
            ${funcs[$option]} ${args[@]}
            args=()
            ;;&
        -h | -c | -f | -r | -v | -l | -p | -t)
            option=${1:1:1}
            shift;;
        --help | --clear | --force | --restore | --version | --list | --print | --trash)
            option=${1:2:1}
            shift;;
        -* | --*)
            echo "${NAME}: invalid option '$1'"
            echo "Try '${NAME} -h' for more informtion"
            exit 1;;
        *) args+=("$1"); shift;;
    esac
done

debug "calling ${funcs[$option]} ${args[@]}"
if [ -z ${funcs[$option]} ]; then
    error "invalid option $option"
    exit 1
fi
${funcs[$option]} ${args[@]}
