#!/usr/bin/env bash

# Split vertically into left and right sides (40% width)
tmux split-window -h -p 40
# Split the right side horizontally (creates bottom-right pane)
tmux split-window -v
# Move focus back to the left side
tmux select-pane -L
# Split the left side horizontally (creates bottom-left pane - 30%)
tmux split-window -v -p 30
# Move focus to the top-left pane
tmux select-pane -U

nvim +NvimTreeFocus "$@"
