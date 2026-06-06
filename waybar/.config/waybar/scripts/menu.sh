#!/bin/bash

about="  About This Computer"
conf="  System Config"
menu="  App Menu"
kill="  Force Kill"
update="  Update System"
power="⏼  Power Options"

item=$(printf "$about\n$conf\n$menu\n$kill\n$update\n$power" | rofi -dmenu -i -l 6 -p "Menu:")

case "$item" in
	"$about")
		kitty -T "about" sh -c "fastfetch --config all.jsonc; read -s"
		;;
	"$conf")
		~/.config/waybar/scripts/config.sh
		;;
	"$menu")
		vicinae vicinae://launch/system/browse-apps
		;;
	"$kill")
		~/.config/niri/force-kill.sh
		;;
	"$update")
		kitty sh -c "yay; read -sp $'\n\e[1;36mPress Enter to exit'"
		;;
	"$power")
		~/.config/waybar/scripts/power-options.sh
		;;
esac

