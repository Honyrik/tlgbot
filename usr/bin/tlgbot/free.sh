#!/bin/sh
. /usr/share/libubox/jshn.sh
json_init
result_command="$(free | awk '/Mem/ {print "ОЗУ: всего "$2" КБ,","использовано "$3" КБ,","свободно "$4" КБ"}')"
json_add_string "message" "${result_command}"
json_close_object
echo "$(json_dump)"
#free | awk '/Swap/ {print "Swap: всего "$2" КБ,","использовано "$3" КБ,","свободно "$4" КБ"}'