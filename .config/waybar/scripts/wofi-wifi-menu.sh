#!/usr/bin/env bash

# A script that generates a wofi menu that uses nmcli to
# toggle, list and connect to wifi networks.

notify-send "Getting list of available Wi-Fi networks..."

wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="󰤭  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="󰤨  Enable Wi-Fi"
fi

# Use wofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | wofi --dmenu --prompt "Wi-Fi SSID:")

# Extract the SSID
chosen_id=$(echo "${chosen_network:3}" | xargs)

if [ -z "$chosen_network" ]; then
	exit
elif [[ "$chosen_network" = *"Enable Wi-Fi"* ]]; then
	nmcli radio wifi on
elif [[ "$chosen_network" = *"Disable Wi-Fi"* ]]; then
	nmcli radio wifi off
else
	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
	saved_connections=$(nmcli -g NAME connection)
	if echo "$saved_connections" | grep -qw "$chosen_id"; then
		nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(wofi --dmenu --prompt "Password:")
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
	fi
fi
