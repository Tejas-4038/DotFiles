#!/bin/bash

SESSION_TYPE="$XDG_SESSION_TYPE"
ENABLED_COLOR="#A3BE8C"
DISABLED_COLOR="#D35F5E"
HIGHLIGHT_COLOR="#a6e3a1"
SIGNAL_ICONS=("󰤟 " "󰤢 " "󰤥 " "󰤨 ")
SECURED_SIGNAL_ICONS=("󰤡 " "󰤤 " "󰤧 " "󰤪 ")
WIFI_CONNECTED_ICON=" "

manage_wifi() {
    nmcli --terse --fields "IN-USE,SIGNAL,SECURITY,SSID" device wifi list > /tmp/wifi_list.txt

    local ssids=()
    local formatted_ssids=()
    local active_ssid=""

    # Add the rescan button at the top
    formatted_ssids+=("<span foreground='#f9e2af'>  Rescan Wi-Fi Networks</span>")
    ssids+=("__rescan__")

    while IFS=: read -r in_use signal security ssid; do
        if [ -z "$ssid" ]; then continue; fi

        local signal_icon="${SIGNAL_ICONS[3]}"
        local signal_level=$((signal / 25))
        if [[ "$signal_level" -lt "${#SIGNAL_ICONS[@]}" ]]; then
            signal_icon="${SIGNAL_ICONS[$signal_level]}"
        fi

        if [[ "$security" =~ WPA || "$security" =~ WEP ]]; then
            signal_icon="${SECURED_SIGNAL_ICONS[$signal_level]}"
        fi

        local formatted="$signal_icon $ssid"

        if [[ "$in_use" =~ \* ]]; then
            active_ssid="$ssid"
            formatted="<span foreground='$HIGHLIGHT_COLOR'>$WIFI_CONNECTED_ICON $formatted</span>"
        fi

        ssids+=("$ssid")
        formatted_ssids+=("$formatted")
    done < /tmp/wifi_list.txt

    local formatted_list=""
    for formatted_ssid in "${formatted_ssids[@]}"; do
        formatted_list+="$formatted_ssid\n"
    done

    formatted_list=$(printf "%s" "$formatted_list")

    local chosen_network=$(echo -e "$formatted_list" | rofi -dmenu -markup-rows -i -p "Wi-Fi SSID: " -theme ~/.config/rofi/themes/wifi-theme.rasi)

    # User closed menu
    if [ -z "$chosen_network" ]; then
        rm /tmp/wifi_list.txt
        return
    fi

    # Detect chosen index
    local ssid_index=-1
    for i in "${!formatted_ssids[@]}"; do
        if [[ "${formatted_ssids[$i]}" == "$chosen_network" ]]; then
            ssid_index=$i
            break
        fi
    done

    local chosen_id="${ssids[$ssid_index]}"

    # 🔄 Handle Rescan button
    if [[ "$chosen_id" == "__rescan__" ]]; then
        notify-send "Wi-Fi" "Scanning for networks…"
        nmcli device wifi rescan
        sleep 5
        manage_wifi   # reload menu
        return
    fi

    # Normal Wi-Fi logic continues ↓
    if [[ "$chosen_id" == "$active_ssid" ]]; then
        action="  Disconnect"
    else
        action="󰸋  Connect"
    fi

    action=$(echo -e "$action\n  Forget" | rofi -dmenu -p "Action: " -theme ~/.config/rofi/themes/wifi-theme.rasi)

    case $action in
        "󰸋  Connect")
            local success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
            local saved_connections=$(nmcli -g NAME connection show)
            if [[ $(echo "$saved_connections" | grep -Fx "$chosen_id") ]]; then
                nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
            else
                local wifi_password=$(rofi -dmenu -p "Password: " -password -theme ~/.config/rofi/themes/wifi-theme.rasi)
                nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
            fi
            ;;
        "  Disconnect")
            nmcli device disconnect wlan0 && notify-send "Disconnected" "You have been disconnected from $chosen_id."
            ;;
        "  Forget")
            nmcli connection delete id "$chosen_id" && notify-send "Forgotten" "The network $chosen_id has been forgotten."
            ;;
    esac

    rm /tmp/wifi_list.txt
}


main_menu() {
    if ! pgrep -x "NetworkManager" > /dev/null; then
        echo -n "Root Password: "
        read -s password
        echo "$password" | sudo -S systemctl start NetworkManager
    fi

    local wifi_status=$(nmcli -fields WIFI g)
    if [[ "$wifi_status" =~ "disabled" ]]; then
        nmcli radio wifi on
        sleep 0.1
    fi

    manage_wifi
}

main_menu "$@"
