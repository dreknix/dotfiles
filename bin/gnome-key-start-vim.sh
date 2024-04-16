#!/usr/bin/env bash

if [ $# -eq 0 ]
then
  target_dir="."
else
  target_dir="$1"
fi

cd "$target_dir" || exit

session="$(pwd | md5sum | cut -c1-6)"

# set up tmux
tmux start-server

if ! tmux has-session -t "$session" 2> /dev/null
then
  # create a new session
  tmux new-session -d -s "$session" -n vim

  # select pane 1 and run vim (close session after vim)
  tmux select-pane -t 1
  tmux send-keys "vim; tmux kill-session" C-m

  # split pane 1 vertically
  tmux split-window -v -p 20

  # select pane 2 and split horizontally
  tmux select-pane -t 2
  tmux split-window -h -p 50

  # select pane 1 (vim) for focus
  tmux select-pane -t 1

  # create a new window called scratch
  tmux new-window -t "$session":2 -n scratch

  # split pane 1 horizontally
  tmux split-window -h -p 50

  # select pane 2 and split vertically
  tmux select-pane -t 2
  tmux split-window -v -p 20

  # select pane 1 for focus
  tmux select-pane -t 1

  # return to main vim window
  tmux select-window -t "$session":1
fi

# attach to session
tmux attach-session -t "$session"
