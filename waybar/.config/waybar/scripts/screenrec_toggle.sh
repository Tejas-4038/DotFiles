#!/bin/bash

pid=$(pgrep wl-screenrec)
time=$(date "+%d-%m-%Y_%H-%M-%S")
path="~/Videos/Screencasts/screenrecord_$time.mp4"
device="$(pactl get-default-sink).monitor"

if [[ -z "$pid" ]]; then
	area=$(printf "Entire Screen\nRegion" | rofi -dmenu -l 2 -p "What to record?")

	case "$area" in
	
		"Entire Screen")
			audio=$(printf "No Audio\nAudio" | rofi -dmenu -l 2 -p "Record Audio?")
			
			case "$audio" in
				"No Audio")
					notify-send "Recording Started without Audio"
					wl-screenrec --codec hevc -f ~/Videos/Screencasts/screenrecord_$time.mp4
					;;
				"Audio")
					notify-send "Recording Started with Audio"			
					wl-screenrec --codec hevc --audio --audio-device $device -f ~/Videos/Screencasts/screenrecord_$time.mp4
					;;
			esac
		;;
		
		"Region")
			region=$(slurp)
			if [[ -z "$region" ]]; then
				exit 1
			fi
			
			size=${region#* }
			width=${size%x*} 
			height=${size#*x}

			if (( width < 128 || height < 128 )); then
				notify-send "Selected region too small"
				exit 1
			fi
			
			audio=$(printf "No Audio\nAudio" | rofi -dmenu -l 2 -p "Record Audio?")

			case "$audio" in
				"No Audio")
					notify-send "Recording Started without Audio"
					wl-screenrec --codec hevc -g "$region" -f ~/Videos/Screencasts/screenrecord_$time.mp4
					echo $?
					;;
				"Audio")
					notify-send "Recording Started with Audio"
					wl-screenrec --codec hevc -g "$region" --audio --audio-device $device -f ~/Videos/Screencasts/screenrecord_$time.mp4
					;;
			esac
		;;

	esac	

else
	kill "$pid"
	notify-send "Recording Stopped"
fi
