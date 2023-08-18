#!/bin/bash

# Date: Sat Aug 5 12:29:55 2023
# Mail: lunar_ubuntu@qq.com
# Author: https://github.com/xiaoqixian

config="$HOME/config.json"

jj -i "${config}" -o "${config}" -v '[{"type": "field","outboundTag": "directTag"}]' -r routing.rules
