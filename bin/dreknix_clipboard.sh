#!/usr/bin/env bash

if [[ $(uname) == "Darwin" ]]
then
  sed -z '$ s/\n$//' | tr --delete '\r' | pbcopy
else
  if command -v wl-copy &> /dev/null
  then
    sed -z '$ s/\n$//' | tr --delete '\r' | wl-copy --primary --paste-once
  else
    # sudo apt install xclip
    sed -z '$ s/\n$//' | tr --delete '\r' | xclip -r -sel clipboard -filter | xclip -r -sel primary
  fi
fi
