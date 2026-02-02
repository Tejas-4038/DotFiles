#!/bin/bash

about="  About This Computer"
conf="  System Config"
menu="  App Menu"
update="  Update System"
power="⏼  Power Options"

item=$(printf "$about\n$conf\n$menu\n$update\n$power" | rofi -dmenu -i -p "Option" -theme "~/.config/rofi/themes/wifi-theme.rasi")

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
	"$update")
		kitty --hold yay
		;;
	"$power")
		~/.config/waybar/scripts/power_options.sh
		;;
esac

