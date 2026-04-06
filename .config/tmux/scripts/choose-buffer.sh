#!/usr/bin/env bash

#
# Enter - paste the selected buffer into current pane
# Ctrl-d - delete the selected buffer
# Ctrl-v - copy the selected buffer to clipboard
#

# Multi column support in fzf:
# --delimiter    - specify the column delimiter
# --with-nth     - string for the list entry, e.g., "{2} ({1}): {3..}"
# --accept-nth   - which column is used after selection
# In preview or bind {1} can select a specific column.

tmux list-buffer -F "#{buffer_name};#{=50:buffer_sample}" | \
  fzf \
    --tmux 80%,80% \
    --no-multi \
    --with-nth "{2..}" --delimiter ";" --accept-nth 1 \
    --border-label ' Choose TMUX Buffer ' \
    --preview-label ' Buffer Content ' \
    --header-label ' Keybindings ' \
    --list-label ' Buffers ' \
    --header '^d - delete | ^v - copy' \
    --bind 'ctrl-d:execute(tmux delete-buffer -b {1})+reload(tmux list-buffer -F "#{buffer_name};#{=50:buffer_sample}")' \
    --bind 'ctrl-v:execute(tmux show-buffer -b {1} | dreknix_clipboard.sh)+abort' \
    --preview-window 'right:70%' \
    --preview "echo -e '{1}\n'; tmux show-buffer -b {1}" | \
  xargs --no-run-if-empty tmux paste-buffer -r -b
