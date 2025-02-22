#!/bin/sh
cmd=$1
inf="br-lan"

if [ "$cmd" == "show" ]; then
    msg=$(cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | sed -e s/*/.../)
    echo "$msg"
elif [[ "$cmd" =~ "^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$" ]]; then
    /usr/bin/etherwake -i "$inf" "$cmd"
    echo "send wake up $cmd"
elif [[ -n "$cmd" ]]; then
    cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep $cmd | cut -f 1 -s -d" " | while read mac; do
        /usr/bin/etherwake -i "$inf" "$mac"
        echo "send wake up $mac"
    done
else
    echo "
        /wakeup show - показать список dhcp client
/wakeup 6c:bf:b5:02:16:e8 - разбудить 6c:bf:b5:02:16:e8
/wakeup name - найти в dhcp client и разбудить
    "
fi