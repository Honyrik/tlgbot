#!/bin/sh
. /usr/share/libubox/jshn.sh
json_init
logread -e dropbear | grep 'auth succeeded for' | sed 's/^.* dropbear\[//' | sed 's/\]:.*//' | sort -u > /tmp/procids

successfullogins="/tmp/procids"

result_command="$(while IFS= read -r procid
do
user=$(logread -e "$procid" | grep 'auth succeeded for' | sed "s/^.*succeeded for '//" | sed "s/'.*from.*//")
ip=$(logread -e "$procid" | grep 'auth succeeded for' | sed 's/^.*from //' | sed 's/\:.*//')
starttime=$(logread -e "$procid" | grep 'auth succeeded for' | sed 's/authpriv.*//' | sed 's/ from.*//')
endtime=$(logread -e "$procid" | grep 'Exit' | sed 's/authpriv.*//')
if [ -z "$endtime" ]; then
endtime="ещё в системе"
fi
echo -e "$user\t$ip\t$starttime"- "$endtime"
done < "$successfullogins")"
json_add_string "message" "${result_command}"
json_close_object
echo "$(json_dump)"
