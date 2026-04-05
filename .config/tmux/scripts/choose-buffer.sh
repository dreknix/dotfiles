#!/usr/bin/env bash

tmux list-buffer -F "#{buffer_name}" | \
  fzf \
    --tmux 80%,80% --border-label ' Choose TMUX Buffer ' \
    --preview "tmux show-buffer -b {}" | \
  xargs --no-run-if-empty tmux paste-buffer -r -b
