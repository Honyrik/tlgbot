#!/bin/sh
ip=$(curl -s api.ipify.org)
. /usr/share/libubox/jshn.sh
json_init
result_command="Публичный IP-адрес: $ip"
json_add_string "message" "${result_command}"
json_close_object
echo "$(json_dump)"