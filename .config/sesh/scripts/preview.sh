#!/usr/bin/env bash

if [ -f "$1/README.md" ]
then
  bat --color=always "$1/README.md"
else
  eza --all --git --icons --oneline --color=always "$1"
fi
