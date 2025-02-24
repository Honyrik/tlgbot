#!/bin/sh
. /usr/share/libubox/jshn.sh
json_init
result_command="$(cat /proc/loadavg | awk -F"[ ]" '{print "Средняя нагрузка: " $1 ", " $2 ", " $3}')"
json_add_string "message" "${result_command}"
json_close_object
echo "$(json_dump)"
