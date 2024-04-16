#!/usr/bin/env bash

#
# sudo apt install rofi locate
#

# theme (font/color) in `.config/rofi/config.rasi`

xdg-open "$(locate -e -i --regex "^/home/$USER/[^\.]+" | rofi -dmenu -i)" > /dev/null 2>&1
