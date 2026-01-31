#!/usr/bin/env bash

# Get current power profile
current=$(powerprofilesctl get)

# Icons
check=""

# Build menu
options=""

# --- PERFORMANCE FIRST ---
if [ "$current" = "performance" ]; then
    options+="<span foreground='#a6e3a1'>󰓅  Performance   $check</span>\n"
else
    options+="󰓅  Performance\n"
fi

# --- BALANCED SECOND ---
if [ "$current" = "balanced" ]; then
    options+="<span foreground='#a6e3a1'>  Balanced      $check</span>\n"
else
    options+="  Balanced\n"
fi

# --- POWER SAVER LAST ---
if [ "$current" = "power-saver" ]; then
    options+="<span foreground='#a6e3a1'>  Power Saver   $check</span>\n"
else
    options+="  Power Saver"
fi

# Show menu
choice=$(echo -e "$options" | rofi -dmenu -markup-rows -p "Power Profile" -theme ~/.config/rofi/themes/wifi-theme.rasi)

# Normalize input (remove check)
clean_choice=$(echo "$choice" | sed "s/$check//" | sed 's/[[:space:]]*$//')

# Apply selected profile
case "$clean_choice" in
    "󰓅  Performance")
        powerprofilesctl set performance && notify-send "Performance" -i "battery-profile-performance"
        ;;
    "  Balanced")
        powerprofilesctl set balanced && notify-send "Balanced" -i "battery-profile-balanced"
        ;;
    "  Power Saver")
        powerprofilesctl set power-saver && notify-send "Power Saver" -i "battery-profile-powersave"
        ;;
esac
