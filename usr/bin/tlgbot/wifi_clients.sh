#!/bin/sh
. /usr/share/libubox/jshn.sh
json_init
result_command="$(for wifi in $(iw dev | grep Interface | cut -f 2 -s -d" ")
do
	if [[ "${wifi}" =~ ^[A-Za-z]+0.*$ ]]; then
		echo -en "---${wifi} - 2.4 ГГц---\n"
	else
		echo -en "---${wifi} - 5 ГГц---\n"
	fi
	macaddr=$(iw dev ${wifi} station dump | grep Station | grep -oE "([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}" | awk '{printf $0 " "}')
	for lease in ${macaddr}
	do
		line=$(cat /tmp/dhcp.leases | grep ${lease})
		if [ $? == 0 ]; then
			echo "${line}" | awk '{gsub( "*","\\*" ); gsub( "_","\\_" ); printf "Устройство: " $4 "\nIP: " $3 "\nMAC: " toupper($2) "\nСостояние: ";system("/usr/bin/tlgbot/functions/ping.sh "$4" 1");printf "\n"}'
		else
			cat /proc/net/arp | grep ${lease} | awk '{gsub( "_","\\_" ); printf "IP: " $1 "\nMAC: " toupper($4) "\nСостояние: ";system("/usr/bin/tlgbot/functions/ping.sh "$1" 1");printf "\n"}'
		fi
		/usr/bin/tlgbot/functions/get_mac.sh "${lease}"
		echo -en "\n"
	done
done)"
json_add_string "message" "${result_command}"
json_close_object
echo "$(json_dump)"