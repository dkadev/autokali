#!/usr/bin/env bash

IFACE="$(ip tuntap show | cut -d : -f1 | head -n 1)"
IP="$(ip a s "${IFACE}" 2>/dev/null | grep -o -P '(?<=inet )[0-9]{1,3}(\.[0-9]{1,3}){3}')"

if [ "${IP}" != "" ]; then
	echo "<txt><span foreground=\"lightgreen\"> 󰖂 $IP </span></txt>"
	echo "<txtclick>bash -c 'printf ${IP} | xclip -selection clipboard | notify-send \"IP ${IP} copied\"'</txtclick>"
	echo "<tool>VPN IP</tool>"
else
	echo "<txt> 󰖂  </txt>"
	echo "<tool>VPN IP</tool>"
fi