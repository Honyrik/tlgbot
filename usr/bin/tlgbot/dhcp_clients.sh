#!/bin/sh
. /usr/share/libubox/jshn.sh
json_init
json_add_string "mode" "HtML"
result_command="<pre>$(for interface in `iw dev | grep Interface | cut -f 2 -s -d" "`
do
  maclist=`iw dev $interface station dump | grep Station | cut -f 2 -s -d" "`
  for mac in $maclist
  do
    ip="UNKN"
    host=""
    ip=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep $mac | cut -f 2 -s -d" "`
    host=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep $mac | cut -f 3 -s -d" "`
    echo -e "$ip\t$host\t$mac"
  done
done)</pre>"
json_add_string "message" "${result_command}"
json_close_object
echo "$(json_dump)"