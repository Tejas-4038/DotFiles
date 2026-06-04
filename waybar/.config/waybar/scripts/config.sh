#!/bin/bash
back="<span foreground='#f9e2af'>Back</span>"
option=$(printf "Niri\nWaybar\nKitty\nZsh\nOther\nGit Repo\n$back"| rofi -dmenu -i -l 7 -markup-rows -kb-remove-char-back "" -kb-custom-1 "BackSpace" -p "Config:")

code=$?

if [ "$code" -eq 10 ]; then
	~/.config/waybar/scripts/menu.sh
	exit
fi

case "$option" in
	"Niri")
		kitty zsh -ic "e ~/.config/niri; exec zsh"
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
