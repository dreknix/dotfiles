#!/usr/bin/env bash

set -x

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

clipboard_wl_copy() {
  wl-copy --primary --paste-once
}

clipboard_x11_copy() {
  xclip -selection primary -filter | xclip -selection clipboard
}

if command -v wl-copy &> /dev/null
then
  CLIPBOARD_COPY=clipboard_wl_copy
else
  CLIPBOARD_COPY=clipboard_x11_copy
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
  | eval ${CLIPBOARD_COPY}
