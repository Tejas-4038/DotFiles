#!/usr/bin/env bash
# Rofi Wi-Fi Manager (Modi version, fixed password prompt)
# Dependencies: nmcli, rofi, awk, notify-send
# Font: Nerd Font (for icons)

theme="$HOME/.config/rofi/themes/wifi-theme.rasi"

# --- Function: List available networks ---
list_networks() {
    nmcli -t -f ACTIVE,SSID,SIGNAL,SECURITY dev wifi list | awk -F: '
    {
        signal=$3; sec=$4;

        # Signal icons
        if (signal >= 80) icon="󰤨";
        else if (signal >= 60) icon="󰤥";
        else if (signal >= 40) icon="󰤢";
        else if (signal >= 20) icon="󰤟";
        else icon="󰤯";

        # Lock / Unlock icons
        lock=(sec == "--") ? "" : "";

        # Connected indicator
        if ($1 == "yes")
            printf("  %s %s  %s\n", icon, lock, $2);
        else
            printf("    %s %s  %s\n", icon, lock, $2);
    }'
}

# --- Function: Connect to Wi-Fi ---
connect_wifi() {
    ssid="$1"
    [[ -z "$ssid" ]] && exit 1

    # If already connected → disconnect
    if nmcli -t -f NAME c show --active | grep -Fxq "$ssid"; then
        nmcli c down "$ssid" >/dev/null 2>&1
        notify-send "📴 Wi-Fi" "Disconnected from $ssid"
        exit 0
    fi

    # Check security
    sec=$(nmcli -t -f SSID,SECURITY dev wifi list | grep -F "$ssid" | awk -F: '{print $2}')

    # Password prompt (in a separate rofi instance)
    if [ "$sec" != "--" ]; then
        pass=$(rofi -dmenu -password -p "Password for $ssid" -theme "$theme")
        [ -z "$pass" ] && notify-send "❌ Cancelled connection to $ssid" && exit 1
    fi

    # Retry loop
    max_attempts=3
    attempt=1
    while [ $attempt -le $max_attempts ]; do
        if [ "$sec" != "--" ]; then
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
}

# --- Main logic (Rofi modi) ---
case "$@" in
    "") list_networks ;;  # show network list
    *)  ssid=$(echo "$@" | awk '{print $NF}')
        # Close Rofi and handle connection externally
        setsid -f bash -c "~/.config/rofi/wifi-menu.sh connect \"$ssid\"" >/dev/null 2>&1 &
        ;;
esac

# --- Handle background connection if 'connect' was passed manually ---
if [[ "$1" == "connect" ]]; then
    shift
    connect_wifi "$@"
fi
