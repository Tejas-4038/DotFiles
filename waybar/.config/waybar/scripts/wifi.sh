#!/bin/bash

SESSION_TYPE="$XDG_SESSION_TYPE"
SIGNAL_ICONS=("󰤟 " "󰤢 " "󰤥 " "󰤨 ")
SECURED_SIGNAL_ICONS=("󰤡 " "󰤤 " "󰤧 " "󰤪 ")
back="<span foreground='#f9e2af'>  Back</span>"

manage_wifi() {
    nmcli --terse --fields "IN-USE,SIGNAL,SECURITY,SSID" device wifi list > /tmp/wifi_list_unorganized.txt

	awk -F: '
	    FNR==NR { 
	    	if (/^\*/) active[$4]=$0;
	    	next 
	    	}
	    	
	    $4 in active {
	     	if (!seen[$4]++) print active[$4];
	     	next
	     	}
	     	
	    !seen[$4]++
	    
	' /tmp/wifi_list_unorganized.txt /tmp/wifi_list_unorganized.txt > /tmp/wifi_list.txt

	local connectivity=$(nmcli networking connectivity)
	local HIGHLIGHT_COLOR="#a6e3a1"
	if [[ "$connectivity" == "limited" || "$connectivity" == "none" ]]; then
		HIGHLIGHT_COLOR="#f38ba8"
	fi
			
    local ssids=()
    local formatted_ssids=()
    local active_ssid=""

    formatted_ssids+=("<span foreground='#f9e2af'>  Rescan Wi-Fi Networks</span>")
    ssids+=("__rescan__")

    while IFS=: read -r in_use signal security ssid; do
        if [ -z "$ssid" ]; then continue; fi

        local signal_icon="${SIGNAL_ICONS[3]}"
        local signal_level=$(((signal - 1 )/ 25))
        
        if [[ "$signal_level" -lt "${#SIGNAL_ICONS[@]}" ]]; then
            signal_icon="${SIGNAL_ICONS[$signal_level]}"
        fi

        if [[ "$security" =~ WPA || "$security" =~ WEP ]]; then
            signal_icon="${SECURED_SIGNAL_ICONS[$signal_level]}"
        fi

        local formatted="$signal_icon $ssid"

        if [[ "$in_use" =~ \* ]]; then
            active_ssid="$ssid"
			formatted="<span foreground='$HIGHLIGHT_COLOR'>$formatted</span>"
        fi


        ssids+=("$ssid")
        formatted_ssids+=("$formatted")
    done < /tmp/wifi_list.txt

    local chosen_network
    chosen_network=$(printf "%s\n" "${formatted_ssids[@]}" | rofi -dmenu -markup-rows -i -p "Wi-Fi:")

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

    if [[ "$chosen_id" == "__rescan__" ]]; then
        rm /tmp/wifi_list.txt
        notify-send "Wi-Fi" "Scanning for networks…"
        nmcli device wifi rescan
        sleep 4
        manage_wifi
        return
    fi

    if [[ "$chosen_id" == "$active_ssid" ]]; then
        action="<span size='14pt'></span>  Disconnect"
    else
        action="󰸋  Connect"
    fi


	autoconnect_status=$(nmcli -g connection.autoconnect connection show "$chosen_id")

	if [[ "$autoconnect_status" = "yes" ]]; then
		autoconnect="\n<span size='14pt'>󱧧</span>  Disable Autoconnect"
	elif [[ "$autoconnect_status" = "no" ]]; then
		autoconnect="\n<span size='14pt'>󰁪</span>  Enable Autoconnect"
	else
		autoconnect=""
	fi
		
    action=$(echo -e "$action\n  Forget $autoconnect\n$back" | rofi -dmenu -kb-remove-char-back "" -kb-custom-1 "BackSpace" -format p -markup-rows -p "Action: ")

	code=$?

	if [ "$code" -eq 10 ]; then
		manage_wifi
		exit
	fi

    case $action in
        "󰸋  Connect")
            local success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
            local saved_connections
            saved_connections=$(nmcli -g NAME connection show)

            if [[ $(echo "$saved_connections" | grep -Fx "$chosen_id") ]]; then
                nmcli connection up id "$chosen_id" | grep "successfully" \
                    && notify-send "Connection Established" "$success_message"
            else
                local wifi_password
                wifi_password=$(rofi -dmenu -p "Password: " -password)

                nmcli device wifi connect "$chosen_id" password "$wifi_password" \
                    | grep "successfully" \
                    && notify-send "Connection Established" "$success_message"
            fi
            ;;
        "  Disconnect")
            nmcli device disconnect wlan0 \
                && notify-send "Disconnected" "You have been disconnected from $chosen_id."
            ;;
        "  Forget")
            nmcli connection delete id "$chosen_id" \
                && notify-send "Forgotten" "The network $chosen_id has been forgotten."
            ;;
        "󱧧  Disable Autoconnect")
        	nmcli connection modify "$chosen_id" connection.autoconnect no \
                && notify-send "Disabled" "Autoconnect has been disabled for $chosen_id."
			;;
		"󰁪  Enable Autoconnect")
        	nmcli connection modify "$chosen_id" connection.autoconnect yes \
        		&& notify-send "Disabled" "Autoconnect has been enabled for $chosen_id"
			;;
        "  Back")
         	manage_wifi
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

    local wifi_status
    wifi_status=$(nmcli -fields WIFI g)
    if [[ "$wifi_status" =~ "disabled" ]]; then
        nmcli radio wifi on
        sleep 0.1
    fi

    manage_wifi
}

main_menu "$@"
