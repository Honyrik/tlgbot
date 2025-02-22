#!/bin/sh
cmd=$1

if [ "$cmd" == "show" ]; then
    echo `cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" "`
elif [[ "$cmd" =~ "^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$" ]]; then
    /usr/bin/etherwake $cmd
    echo "send wake up $cmd"
elif [[ -n "$cmd" ]]; then
    cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep $cmd | cut -f 1 -s -d" " | while read mac; do
        /usr/bin/etherwake $mac
        echo "send wake up $mac"
    done
else
    echo "
        /wakeup show - показать список dhcp client
        /wakeup 6c:bf:b5:02:16:e8 - разбудить 6c:bf:b5:02:16:e8
        /wakeup name - найти в dhcp client и разбудить
    "
fi