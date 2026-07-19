#!/usr/bin/env bash

if [ -n "${DREKNIX_GOPASS_FILTER}" ]
then
  QUERY="--query=${DREKNIX_GOPASS_FILTER}"
else
  QUERY=""
fi
selected=$(gopass ls --flat | \
  fzf \
    ${QUERY} \
    --popup 70%,70% \
    --ignore-case \
    --no-multi \
    --no-sort \
    --preview-window wrap \
    --preview "echo -e '\033[0;35mSecret: {}\033[0m\n'; if gopass show --nosync {} > /dev/null 2>&1; then gopass show --nosync {} | bat --style=-numbers -l YAML; else echo -e '\033[1;33m⚠ show.safecontent=true\033[0m\ncontains only password'; fi" \
)
if [ -n "$selected" ]
then
  gopass show --nosync --password --unsafe "$selected" | dreknix_clipboard.sh
fi
