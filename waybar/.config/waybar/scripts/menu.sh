#!/bin/bash

about="  About This Computer"
conf="  System Config"
menu="  App Menu"
kill="  Force Kill"
update="  Update System"
power="⏼  Power Options"

item=$(printf "$about\n$conf\n$menu\n$kill\n$update\n$power" | rofi -dmenu -i -p "Menu:")

case "$item" in
	"$about")
		kitty --hold fastfetch
		;;
	"$conf")
		~/.config/waybar/scripts/config.sh
		;;
	"$menu")
		vicinae deeplink vicinae://extensions/vicinae/system/browse-apps
		;;
	"$kill")
		hyprctl kill
		;;
	"$update")
		kitty --hold yay
		;;
	"$power")
		~/.config/waybar/scripts/power-options.sh
		;;
esac

