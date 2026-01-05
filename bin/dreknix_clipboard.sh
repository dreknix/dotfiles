#!/usr/bin/env bash

if [[ $(uname) == "Darwin" ]]
then
  tr -d '\r' | pbcopy
else
  if command -v wl-copy &> /dev/null
  then
    tr -d '\r' | wl-copy --primary --paste-once
  else
    # sudo apt install xclip
    tr -d '\r' | xclip -r -sel clipboard -filter | xclip -r -sel primary
  fi
fi
