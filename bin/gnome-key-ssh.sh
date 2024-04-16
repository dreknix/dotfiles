#!/usr/bin/env bash

#
# sudo apt install rofi
#
# see ~/.config/run-or-raise/shortcuts.conf

# theme (font/color) in `.config/rofi/config.rasi`

if [ -x "/usr/local/bin/st" ]
then
  export TERMINAL="/usr/local/bin/st"
else
  if [[ "$XDG_CURRENT_DESKTOP" =~ XFCE ]]
  then
    export TERMINAL="/usr/bin/xfce4-terminal.wrapper"
  else
    export TERMINAL="/usr/bin/gnome-terminal"
  fi
fi

rofi \
  -show ssh \
  -matching fuzzy \
  -i
