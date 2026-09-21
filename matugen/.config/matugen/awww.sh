#!/bin/bash

wall="$1"
blur="/tmp/niri-overview-wallpaper.png"

magick "$wall" -blur 0x20 -fill black -colorize 50% "$blur"

awww img "$wall" -t center --transition-duration=1 --transition-fps=255
awww img -n overview "$blur"
