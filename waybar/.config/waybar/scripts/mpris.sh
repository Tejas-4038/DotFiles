#!/bin/bash

status=$(playerctl status)
if ! [[ $status = "Playing" || $status = "Paused" ]]; then
	exit 0
fi

player=$(playerctl metadata --format '{{playerName}}')
title=$(playerctl metadata title)
title_short=$(playerctl metadata --format '{{trunc(title, 30)}}')
artist=$(playerctl metadata artist)
album=$(playerctl metadata album)


case "$player" in
	"spotify")
		icon="<span foreground='#a6e3a1'>󰓇 </span>"
		;;
	"firefox")
		icon="<span foreground='#f38ba8'>󰗃 </span>"
		;;
	"YoutubeMusic")
		icon="<span foreground='#f38ba8'> </span>"
		;;
	*)
		icon="<span foreground='#cba6f7'>󰝚 </span>"
		;;
esac


# Progress Bar
sec_passed=$(playerctl position)
sec_passed=${sec_passed%.*}
time_passed=$(playerctl metadata --format '{{duration(position)}}')

length_sec=$(( $(playerctl metadata mpris:length) / 1000000 ))
length_time=$(playerctl metadata --format '{{duration(mpris:length)}}')

bar_width=35

perc_done=$(( sec_passed * bar_width / length_sec ))


bar='['

for (( i = 0; i < perc_done; i++ )); do
	bar+='-'
done
for (( i = perc_done; i < bar_width; i++ )); do
	bar+=' '
done

bar+=']'


printf '{"text": "%s %s", "tooltip": "%s — %s\\n%s %s %s"}\n' "$icon" "$title_short" "$title" "$artist" "$time_passed" "$bar" "$length_time"
