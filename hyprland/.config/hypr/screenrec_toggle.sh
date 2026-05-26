#!/bin/bash

pid=$(pgrep wl-screenrec)
time=$(date "+%d-%m-%Y_%H-%M-%S")
path="~/Videos/Screencasts/screenrecord_$time.mp4"

if [[ -z "$pid" ]]; then
	notify-send "Recording Started"
	wl-screenrec --codec hevc -f ~/Videos/Screencasts/screenrecord_$time.mp4
else
	kill "$pid"
	notify-send "Recording Stopped"
fi
