#!/bin/sh
uptime=$(cat /proc/uptime | cat /proc/uptime | awk -F"[. ]" '{print $1}')
idle=$(cat /proc/uptime | cat /proc/uptime | awk -F"[. ]" '{print $3}')
. /usr/share/libubox/jshn.sh
json_init
result_command="$(printf 'Роутер работает %dд %dч %dм %dс\n'  $((uptime/86400)) $((uptime%86400/3600)) $((uptime%3600/60)) $((uptime%60)))
$(printf 'Из них в простое %dд %dч %dм %dс\n'  $((idle/86400)) $((idle%86400/3600)) $((idle%3600/60)) $((idle%60)))"
json_add_string "message" "${result_command}"
json_close_object
echo "$(json_dump)"