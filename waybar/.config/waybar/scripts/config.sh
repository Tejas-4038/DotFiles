#!/bin/bash
back="<span foreground='#f9e2af'>Back</span>"
option=$(printf "Hyprland\nWaybar\nKitty\nZsh\nGTK Settings\nOther\nGit Repo\n$back"| rofi -dmenu -i -markup-rows -kb-remove-char-back "" -kb-custom-1 "BackSpace" -p "Config:" -theme "~/.config/rofi/themes/wifi-theme.rasi")

code=$?

if [ "$code" -eq 10 ]; then
	~/.config/waybar/scripts/menu.sh
	exit
fi

case "$option" in
	"Hyprland")
		kitty zsh -ic "e ~/.config/hypr; exec zsh"
		;;
	"Waybar")
		kitty zsh -ic "e ~/.config/waybar; exec zsh"
		;;
	"Kitty")
		kitty micro ~/.config/kitty/kitty.conf
		;;
	"Zsh")
		kitty micro ~/.zshrc
		;;
	"GTK Settings")
		nwg-look
		;;
	"Other")
		kitty zsh -ic "e ~/.config/; exec zsh"
		;;
	"Git Repo")
		kitty -d ~/DotFiles
		;;
	"$back")
		~/.config/waybar/scripts/menu.sh
		;;
esac
