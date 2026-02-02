#!/bin/bash
back="<span foreground='#f9e2af'>Back</span>"
option=$(printf "Hyprland\nWaybar\nKitty\nZsh\nOther\nGit Repo\n$back"| rofi -dmenu -i -markup-rows -p "Select Config" -theme "~/.config/rofi/themes/wifi-theme.rasi")

case "$option" in
	"Hyprland")
		EDITOR=micro kitty ~/.yazi.sh ~/.config/hypr
		;;
	"Waybar")
		EDITOR=micro kitty ~/.yazi.sh ~/.config/waybar
		;;
	"Kitty")
		kitty micro ~/.config/kitty/kitty.conf
		;;
	"Zsh")
		kitty micro ~/.zshrc
		;;
	"Other")
		EDITOR=micro kitty ~/.yazi.sh ~/.config/
		;;
	"Git Repo")
		kitty -d ~/DotFiles
		;;
	"$back")
		~/.config/waybar/scripts/menu.sh
		;;
esac
