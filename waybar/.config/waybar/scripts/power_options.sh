#!/bin/bash

shutdown="⏻  Shut Down"
reboot="  Reboot"
logout="  Logout"
suspend="  Suspend"
lock="  Lock Screen"
back="<span foreground='#f9e2af'>  Back</span>"

power=$(printf "$shutdown\n$reboot\n$logout\n$suspend\n$lock\n$back" | rofi -dmenu -i -markup-rows -p "Power Option" -theme "~/.config/rofi/themes/wifi-theme.rasi")

case "$power" in 
	"$shutdown")
		systemctl poweroff
		;;
	"$reboot")
		systemctl reboot
		;;
	"$logout")
		hyprctl dispatch exit
		;;
	"$suspend")
		systemctl suspend
		;;
	"$lock")
		hyprlock
		;;
	"$back")
		~/.config/waybar/scripts/menu.sh
		;;
esac
