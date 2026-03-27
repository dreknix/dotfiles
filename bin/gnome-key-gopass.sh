#!/usr/bin/env bash

#
# gopass from https://github.com/gopasspw/gopass/releases
#
# sudo apt install suckless-tools (for dmenu)
#
# sudo apt install xclip
#
# see ~/.config/run-or-raise/shortcuts.conf

FONT="Hack Nerd Font Mono:size=13"

# tomorrow night
FG="#2d2d2d"
BG="#6699cc"
SFG="#2d2d2d"
SBG="#f99157"

if [ "$(uname)" == "Darwin" ]; then
  # change focus to XQuartz
  open -a XQuartz
fi

if command -v wofi &> /dev/null
then
  MENU=("wofi" "--dmenu" "--prompt" "" "--height" "90%" "--width" "90%" "--normal-window")
else
  MENU=("dmenu" "-i" "-f" "-p" "❯ " "-nf" "$FG" "-nb" "$BG" "-sf" "$SFG" "-sb" "$SBG" "-fn" "$FONT")
fi

gopass ls --flat \
  | "${MENU[@]}" \
  | xargs --no-run-if-empty gopass show --password \
  | head -n 1 \
  | tr -d '\n' \
  | dreknix_clipboard.sh

if [ "$(uname)" == "Darwin" ]; then
  # change focus back to previous application
  osascript -e 'tell application "System Events" to keystroke tab using {command down}'
fi
