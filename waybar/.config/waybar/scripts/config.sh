#!/bin/bash

option=$(printf "Hyprland\nWaybar\nKitty\nZsh\nOther"| rofi -dmenu -p "Select Config" -theme "~/.config/rofi/themes/wifi-theme.rasi")

case "$option" in

	"Hyprland")
		kitty yazi ~/.config/hypr
		;;

	"Waybar")
		kitty yazi ~/.config/waybar
		;;

	"Kitty")
		kitty micro ~/.config/kitty/kitty.conf
		;;

	"Zsh")
		kitty micro ~/.zshrc
		;;

	"Other")
		kitty yazi ~/.config/
		;;

esac
