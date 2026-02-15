#!/bin/bash

state=$(nmcli radio wifi)

if [ "$state" = "enabled" ]; then
    nmcli radio wifi off && notify-send 'Wifi Disabled' -i 'network-wireless-off'
else
    nmcli radio wifi on && notify-send 'Wifi Enabled' -i 'network-wireless-on'
fi
