#!/usr/bin/env bash

#
# sudo apt install rofi mlocate
#

# theme (font/color) in `.config/rofi/config.rasi`

# search which directories (stored in ~/.shell_common_local.sh)
if [ -z "$START_DIR_DIRS" ]
then
  if [ -f "${HOME}/.shell_common_local.sh" ]
  then
    # shellcheck source=/dev/null
    source "${HOME}/.shell_common_local.sh"
  fi
fi
if [ -z "$START_DIR_DIRS" ]
then
  dirs="$HOME"
else
  dirs="$START_DIR_DIRS"
fi

target_dir="$(fdfind --type directory --hidden --no-ignore-vcs --exclude ".git" --exclude ".direnv" --exclude ".svn" "" $dirs | rofi -dmenu -i)" > /dev/null 2>&1

title_dir="$(cd "$target_dir" && dirs +0)"

# start tmux only if a directory was selected
if [ "$title_dir" != "~" ]
then
  gnome-terminal --title "tmux - $title_dir" \
                 --no-environment \
                 --maximize \
                 --window \
                 --working-directory="$target_dir" \
                 -- bash -i -l -c gnome-key-start-vim.sh
fi
