#!/bin/sh
uptime=$(jsonfilter -s "$(ifstatus wan)" -e '$.uptime')
. /usr/share/libubox/jshn.sh
json_init
result_command="$(printf 'WAN-интерфейс работает %dд %dч %dм %dс\n'  $((uptime/86400)) $((uptime%86400/3600)) $((uptime%3600/60)) \
  $((uptime%60)))"
json_add_string "message" "${result_command}"
json_close_object
echo "$(json_dump)"