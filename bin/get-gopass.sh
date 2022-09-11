#!/usr/bin/env bash

set -e
# set -v -x

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
    gopass ls --flat "$1" | grep -iq "${2}" || (
      echo "$0: Pattern '$2' not found in store '$1'" >&2
      exit 20
    )
    path=$(gopass ls --flat "$1" | grep -i "${2}")
    ;;
  3)
    # usage: get-gopass.sh <store> <pattern> <pattern>
    gopass ls --flat "$1" | grep -i "${2}" | grep -iq "${3}" || (
      echo "$0: Patterns '$2' and '${3}' not found in store '$1'" >&2
      exit 20
    )
    path=$(gopass ls --flat "$1" | grep -i "${2}" | grep -i "${3}")
    ;;
  *)
    echo "usage: $0 [<pattern> | <store> <pattern> | <store> <pattern> <pattern>]" >&2
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
