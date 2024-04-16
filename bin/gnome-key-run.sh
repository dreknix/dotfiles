#!/usr/bin/env bash

#
# sudo apt install rofi
#
# see ~/.config/run-or-raise/shortcuts.conf

# theme (font/color) in `.config/rofi/config.rasi`

rofi \
  -steal-focus \
  -show drun \
  -matching fuzzy \
  -i
