#!/usr/bin/env bash

set -e
# set -v -x

if [ "$#" -eq 0 ]
then
  set -- "${ANSIBLE_VAULT_IDENTITY}"
fi

case "$#" in
  1)
    # usage: get-gopass.sh <pattern>
    gopass ls --flat | fzf -i --no-sort --filter "${1}" > /dev/null 2>&1 || (
      echo "$0: Path '$1' not found" >&2
      exit 10
    )
    path=$(gopass ls --flat | fzf -i --no-sort --filter "${1}")
    ;;
  2)
    # usage: get-gopass.sh <store> <pattern>
    gopass ls --flat "$1" | fzf -i --no-sort --filter "${2}" > /dev/null 2>&1 || (
      echo "$0: Pattern '$2' not found in store '$1'" >&2
      exit 20
    )
    path=$(gopass ls --flat "$1" | fzf -i --no-sort --filter "${2}")
    ;;
  *)
    echo "usage: $0 [ <pattern> | <store> <pattern> ]" >&2
    exit 90
esac
if [ "$(echo "${path}" | wc -l)" -ne 1 ]
then
  echo "$0: path is not unique" 2>&1
  exit 99
fi

# disable gopass notifications
export GOPASS_NO_NOTIFY=false

# gopass must be so configured that only the password is printed
gopass show --force --password "${path}"
