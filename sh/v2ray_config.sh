# Date: Thu Aug 17 13:11:45 2023
# Mail: lunar_ubuntu@qq.com
# Author: https://github.com/xiaoqixian

#CONFIG="$HOME/config.json"
CONFIG="/usr/local/etc/v2ray/config.json"
NAME="v2ray_config"

echo_red() {
    echo -e "\e[0;31m$@\e[0m"
}
echo_green() {
    echo -e "\e[0;32m$@\e[0m"
}
error() {
    echo -e "\e[0;31m[ERROR] $@\e[0m"
}
debug() {
    #echo -e "\e[0;32m[DEBUG] $@\e[0m"
    :
}

if [ ! -f "${CONFIG}" ]; then
    echo "${NAME}: invalid config file path '${CONFIG}': File not exists"
    exit 1
fi

if [ ! command -v jj &> /dev/null ]; then
    echo "json editing tool jj needed."
    echo "Try 'brew install tidwall/jj/jj'"
    exit 0
fi

declare -A -r loglevels=(
    ["info"]="i"
    ["warning"]="w"
    ["debug"]="d"
    ["error"]="e"
    ["none"]="n"
)

edit_config() {
    jj -i "${CONFIG}" -o "${CONFIG}" -v "$1" -r $2
}

set_loglevel() {
    if [ -z "${loglevels[$1]}" ]; then
        echo "${NAME}: invalid loglevel '$1'"
        exit 1
    fi

    edit_config '"'"$1"'"' "log.loglevel"
}

set_domain() {
    debug "setting domain to $1"
    edit_config '"'"$1"'"' "outbounds.0.settings.vnext.0.address"
}

set_uuid() {
    debug "setting uuid to $1"
    edit_config '"'"$1"'"' "outbounds.0.settings.vnext.0.users.0.id"
}

set_inbound_port() {
    debug "setting inbound port to $1"
    edit_config '"'"$1"'"' "inbounds.0.port"
}

set_outbound_port() {
    debug "setting outbound port to $1"
    edit_config '"'"$1"'"' "outbounds.0.settings.vnext.0.port"
}

set_ws_path() {
    debug "settings websocket path to $1"
    edit_config '"'"$1"'"' ""
}

set_global() {
    debug "setting global mode"
    #jj -i "${CONFIG}" -o "${CONFIG}" -v '[{"type": "field", "inboundTag": "http", "outboundTag": "proxyTag"}]' -r routing.rules
    edit_config '[{"type": "field", "inboundTag": "http", "outboundTag": "proxyTag"}]' "routing.rules"
}

set_direct() {
    debug "setting direct mode"
    edit_config '[{"type": "field", "inboundTag": "http", "outboundTag": "directTag"}]' "routing.rules"
    #jj -i "${CONFIG}" -o "${CONFIG}" -v '[{"type": "field", "inboundTag": "http", "outboundTag": "directTag"}]' -r routing.rules
}

set_routing() {
    debug "setting routing mode"
    edit_config '[{"type": "field", "outboundTag": "directTag", "domain": ["geosite:cn"]}, {"type": "field", "outboundTag": "directTag", "ip": ["geoip:cn", "geoip:private"]}, {"type": "field", "outboundTag": "proxyTag", "network": "udp, tcp"}]' "routing.rules"
    #jj -i "${CONFIG}" -o "${CONFIG}" -v '[{"type": "field", "outboundTag": "directTag", "domain": ["geosite:cn"]}, {"type": "field", "outboundTag": "directTag", "ip": ["geoip:cn", "geoip:private"]}, {"type": "field", "outboundTag": "proxyTag", "network": "udp, tcp"}]' -r routing.rules
}

declare -A -r modes=(
    ["routing"]="set_routing"
    ["global"]="set_global"
    ["direct"]="set_direct"
)

while [ $# -gt 0 ]; do
    case "$1" in
        -m | --mode)
            debug "$2"
            if [[ -z "${modes["$2"]}" ]]; then
                error "invalid mode '$2'"
                exit 1
            fi
            ${modes["$2"]}
            shift 2;;

        -l | --level)
            set_loglevel "$2"
            shift 2;;

        -d | --domain)
            set_domain "$2"
            shift 2;;

        -o | --outbound_port)
            set_outbound_port "$2"
            shift 2;;

        -i | --inbound_port)
            set_inbound_port "$2"
            shift 2;;

        -u | --uuid)
            set_uuid "$2"
            shift 2;;

        -p | --ws_path)
            set_ws_path "$2"
            shift 2;;
    esac
done

brew services restart v2ray
