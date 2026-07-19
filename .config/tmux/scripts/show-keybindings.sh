#!/usr/bin/env bash

# shellcheck disable=SC2016
awk_preview='$4=="{1}" { for(i=5; i<=NF; ++i) printf "%s ", $i; print "" }'
fzf_preview="tmux list-keys -T tpm-bindings \
  | awk '$awk_preview' \
  | bat --style=-numbers -l Tmux"

tmux list-keys -N -T dreknix-bindings | \
  awk '{ printf "%s - ", $2; for(i=3; i<=NF; ++i) printf "%s ", $i; print "" }' | \
  fzf --popup=70%,70% \
      --delimiter "-" \
      --accept-nth 1 \
      --border-label "  Help - Show keybindings for C-a g  " \
      --preview-window wrap:65% \
      --preview "$fzf_preview" > /dev/null

# ignore error codes from fzf
true
