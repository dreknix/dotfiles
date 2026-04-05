#!/usr/bin/env bash

#
# Enter - paste the selected buffer into current pane
# Ctrl-d - delete the selected buffer
# Ctrl-v - copy the selected buffer to clipboard
#

tmux list-buffer -F "#{buffer_name}" | \
  fzf \
    --tmux 80%,80% \
    --border-label ' Choose TMUX Buffer ' \
    --preview-label ' Buffer Content ' \
    --header-label ' Keybindings ' \
    --list-label ' Buffers ' \
    --header '^d - delete | ^v - copy' \
    --bind 'ctrl-d:execute(tmux delete-buffer -b {})+reload(tmux list-buffer -F "#{buffer_name}")' \
    --bind 'ctrl-v:execute(tmux show-buffer -b {} | dreknix_clipboard.sh)+abort' \
    --preview-window 'right:70%' \
    --preview "tmux show-buffer -b {}" | \
  xargs --no-run-if-empty tmux paste-buffer -r -b
