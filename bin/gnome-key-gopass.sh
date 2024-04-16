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

gopass ls --flat \
  | dmenu -i -f -p "❯ " -nf "$FG" -nb "$BG" -sf "$SFG" -sb "$SBG" -fn "$FONT" \
  | xargs --no-run-if-empty gopass show --password \
  | head -n 1 \
  | tr -d '\n' \
  | xclip -selection primary -filter \
  | xclip -selection clipboard
