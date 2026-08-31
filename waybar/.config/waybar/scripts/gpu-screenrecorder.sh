#!/bin/bash

pid=$(pgrep -f "^gpu-screen-recorder")
time=$(date "+%d-%m-%Y_%H-%M-%S")
path="$HOME/Videos/Screencasts/screenrecord_$time.mp4"

if [[ -z "$pid" ]]; then

	region=$(printf "Entire Screen\nRegion" | rofi -dmenu -l 2 -p "Region")
	case "$region" in
		"Entire Screen") region="screen"	;;
		"Region") region="$(slurp -f "%wx%h+%x+%y")" ;;
		"") exit ;;
	esac

	audio=$(printf "No Audio\nDesktop Audio\nMicrophone\nDesktop Audio + Microphone" | rofi -dmenu -l 4 -p "Audio")
	case "$audio" in
		"No Audio") audio="" ;;
		"Desktop Audio") audio="default_output" ;;
		"Microphone") audio="default_input" ;;
		"Desktop Audio + Microphone") audio="default_output|default_input" ;;
		"") exit ;;
	esac

	cam=$(printf "No Webcam\nWebcam" | rofi -dmenu -l 2 -p "Webcam")
	case "$cam" in
		"Webcam") region+="|/dev/video0;halign=end;valign=end;width=25%;height=25%" ;;
		"") exit ;;
	esac

	notify-send "Recording Started"
	gpu-screen-recorder -w "$region" -f 60 -k hevc -a "$audio" -o "$path"

else
	pkill -SIGINT -f "^gpu-screen-recorder" && notify-send "Recording Stopped"
fi
