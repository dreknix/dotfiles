#!/usr/bin/env bash

#
# sudo apt install rofi
#

# theme (font/color) in `.config/rofi/config.rasi`

rofi \
  -steal-focus \
  -show drun \
  -matching fuzzy \
  -i
