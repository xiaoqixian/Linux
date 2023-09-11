# Date: Fri Aug  4 17:08:02 2023
# Mail: lunar_ubuntu@qq.com
# Author: https://github.com/xiaoqixian

ws_path="blog"
loglevel="Info"
logpath="/dev/null"

usage() {
    echo "
    -d | --domain  : server domain\n
    -w | --wspath  : v2ray websocket path\n
    -i | --id      : v2ray uuid\n
    -p | --logpath : v2ray log output path\n
    -l | --loglevel: loglevel[info | debug | error]\n
    -h | --help   : this message\n
    "
}

while [ $# -gt 0 ]; do
    case "$1" in
        -d | --domain) domain="$2"; shift 2;;
        -w | --wspath) ws_path="$2"; shift 2;;
        -i | --id) id="$2"; shift 2;;
        -p | --logpath) logpath="$2"; shift 2;;
        -l | --loglevel) loglevel="$2"; shift 2;;
        -h | --help) usage; shift;;
        *) echo "Unrecognized option '$1'"; exit 1;;
    esac
done

# curl needed
if ! command -v curl -V &> /dev/null
then
    echo "curl not found"
    exit
fi

# get acme.sh 
if ! command -v crontab -v &> /dev/null
then
    echo "You need install crontab first"
    exit
fi
curl https://get.acme.sh | sh
.acme.sh/acme.sh --set-default-ca --server letsencrypt

if ! command -v nginx -v &> /dev/null
then
    echo "you need to install nginx first"
    exit
fi

if command -v firewall-cmd -v &> /dev/null
then
    firewall-cmd --zone=public --add-port 80/tcp --permanent
    firewall-cmd --reload
fi

# modify nginx config file
cp /etc/nginx/nginx.conf $HOME/nginx.conf
sed -i "0,/server_name/{s/server_name .*/server_name $domain;/}" $HOME/nginx.conf
nginx -c $HOME/nginx.conf -s reload

# issue cirtificate
.acme.sh/acme.sh --issue --domain-name $domain --nginx

# add https server in nginx.conf
ssl_server="\
    server {\n\
        listen 443 ssl\n\
        listen [::]:443 ssl;\n\
        \n\
        ssl_certificate       $HOME/${domain}_ecc/fullchain.cer;\n\
        ssl_certificate_key $HOME/${domain}_ecc/${domain}.key;   \n\
        ssl_session_timeout 1d;\n\
        ssl_session_cache shared:MozSSL:10m;\n\
        ssl_session_tickets off;\n\
        \n\
        ssl_protocols         TLSv1.2 TLSv1.3;\n\
        ssl_ciphers           ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;\n\
        ssl_prefer_server_ciphers off;\n\
        \n\
        server_name ${domain};\n\
        location / {\n\
            root /usr/share/nginx/html;\n\
        }\n\
        \n\
        location /${wspath} {\n\
            if (\$http_upgrade != \"websocket\") {\n\
                return 404;\n\
            }\n\
            proxy_redirect off;\n\
            proxy_pass http://127.0.0.1:${port};\n\
            proxy_http_version 1.1;\n\
            proxy_set_header Upgrade \$http_upgrade;\n\
            proxy_set_header Connection \"upgrade\";\n\
            proxy_set_header Host \$host;\n\
            proxy_set_header X-Real-IP \$remote_addr;\n\
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;\n\
        }\n\
    }"

sed -i "$ i ${ssl_server}" nginx.conf

# check if v2ray exists
if ! command -v v2ray -version &> /dev/null
then
    echo "installing v2ray from github"
    sh <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
fi

if ! command -v v2ray -version &> /dev/null
then
    echo "v2ray installation failed"
    exit
fi

touch config.json

echo "{
    \"log\": {
        \"loglevel\": \"${loglevel}\"
    },
    \"routing\": {
        \"domainStrategy\": \"AsIs\",
        \"rules\": [
            {
                \"ip\": [
                    \"geoip:private\"
                ],
                \"outboundTag\": \"blocked\",
                \"type\": \"field\"
            }
        ]
    },
    \"inbounds\": [
        {
            \"listen\": \"127.0.0.1\",
            \"port\": ${port},
            \"protocol\": \"vmess\",
            \"settings\": {
                \"clients\": [
                    {
                        \"id\": \"${id}\",
                        \"alterId\": 0
                    }
                ]
            },
            \"streamSettings\": {
                \"network\": \"ws\",
                \"wsSettings\": {
                    \"path\": \"/${wspath}\"
                }
           }
        }
    ],
    \"outbounds\": [
        {
            \"protocol\": \"freedom\"
        },
        {
            \"protocol\": \"blackhole\",
            \"tag\": \"blocked\"
        }
    ]
}" > config.json

nohup v2ray -c config.json > ${logpath} 2>&1 &
