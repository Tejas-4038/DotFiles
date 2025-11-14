#!/bin/bash

# Dependencies: nmcli, rofi, awk, notify-send
# Optional: Nerd Font (for icons)

# --- Get available Wi-Fi networks ---
wifi_list=$(nmcli -t -f ACTIVE,SSID,SIGNAL,SECURITY dev wifi list | awk -F: '
{
    signal=$3
    security=$4

    # Determine signal icon
    if (signal >= 80) icon="󰤨"
    else if (signal >= 60) icon="󰤥"
    else if (signal >= 40) icon="󰤢"
    else if (signal >= 20) icon="󰤟"
    else icon="󰤯"

    # Add lock icon if secured
    if (security != "--") lock=""
    else lock=""

    if ($1 == "yes")
        printf("  %s %s  %s%%  %s\n", icon, lock, signal, $2)
    else
        printf("    %s %s  %s%%  %s\n", icon, lock, signal, $2)
}')

# --- Display in Rofi ---
chosen_network=$(echo "$wifi_list" | rofi -dmenu -p "Wi-Fi" -theme ~/.config/rofi/themes/wifi-theme.rasi)

# --- Extract SSID ---
ssid=$(echo "$chosen_network" | awk '{print $NF}')
[ -z "$ssid" ] && exit

# --- Connection attempt loop ---
max_attempts=3
attempt=1

while [ $attempt -le $max_attempts ]; do
    # Check if network is open
    security=$(nmcli -t -f SSID,SECURITY dev wifi list | grep -F "$ssid" | awk -F: '{print $2}')

    if [ "$security" != "--" ]; then
        # Prompt for password using Rofi
        pass=$(rofi -dmenu -password -p "Password for $ssid" -theme ~/.config/rofi/themes/wifi-theme.rasi)
        [ -z "$pass" ] && notify-send "❌ Cancelled connection to $ssid" && exit
        nmcli dev wifi connect "$ssid" password "$pass"
    else
        nmcli dev wifi connect "$ssid"
    fi

    if [ $? -eq 0 ]; then
        notify-send "📶 Connected to $ssid"
        exit 0
    else
        notify-send "⚠️ Failed to connect to $ssid (attempt $attempt/$max_attempts)"
        ((attempt++))
    fi
done

notify-send "❌ Could not connect to $ssid after $max_attempts attempts"
exit 1
