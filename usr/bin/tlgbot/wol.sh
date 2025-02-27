#!/bin/sh
cmd=$1
inf="br-lan"
. /usr/share/libubox/jshn.sh
json_init
result_command="Похоже, на эльфийском. Я не могу прочесть"
json_add_string "mode" "HtML"
if [ "$cmd" == "show" ]; then
    msg=$(cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" ")
    result_command="<pre>${msg}</pre>"
elif [[ "$cmd" =~ "^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$" ]]; then
    /usr/bin/etherwake -i "$inf" "$cmd"
    result_command="send wake up $cmd"
elif [[ -n "$cmd" ]]; then
    result_command="$(cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep -i $cmd | cut -f 1 -s -d" " | while read mac; do
        /usr/bin/etherwake -i "$inf" "$mac"
        echo "send wake up $mac"
    done)"
else
    result_command="<pre>/wol show</pre> - показать список dhcp client
<pre>/wol 6c:bf:b5:02:16:e8</pre> - разбудить 6c:bf:b5:02:16:e8
<pre>/wol name</pre> - найти в dhcp client и разбудить"
fi
json_add_string "message" "${result_command}"
json_close_object
echo "$(json_dump)"
