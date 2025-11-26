#!/bin/bash

status=$(playerctl status 2>/dev/null)

if [[ "$status" == "Playing" ]]; then
    echo "󰏤"
elif [[ "$status" == "Paused" ]]; then
    echo "󰐊"
else
    echo ""
fi
