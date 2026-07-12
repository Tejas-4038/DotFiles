
#!/bin/bash

source ~/.config/waybar/scripts/mpris-colors.sh

status=$(playerctl status)
if ! [[ $status = "Playing" || $status = "Paused" ]]; then
	exit 0
fi

escape_markup() {
    sed \
        -e 's/&/\&amp;/g' \
        -e 's/</\&lt;/g' \
        -e 's/>/\&gt;/g'
}

player=$(playerctl metadata --format '{{playerName}}')
title=$(playerctl metadata title | escape_markup)
title_short=$(playerctl metadata --format '{{trunc(title, 30)}}' | escape_markup)
artist=$(playerctl metadata artist | escape_markup)


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
	bar+='='
done
for (( i = perc_done; i < bar_width; i++ )); do
	bar+=' '
done

bar+=']'

time_passed="<span foreground='$tertiary'>$time_passed</span>"
bar="<span foreground='$primary'>$bar</span>"
length_time="<span foreground='$tertiary'>$length_time</span>"

tooltip="$title — $artist"$'\n'"$time_passed $bar $length_time"

if [[ $status == "Playing" ]]; then
    jq -nc \
        --arg text "$icon $title_short" \
        --arg tooltip "$tooltip" \
        '{text: $text, tooltip: $tooltip}'

elif [[ $status == "Paused" ]]; then
    jq -nc \
        --arg text "<i>$icon $title_short</i>" \
        --arg tooltip "$tooltip" \
        '{text: $text, tooltip: $tooltip}'
fi
