#!/usr/bin/env bash

set -e
# set -v -x

if [ -z "$RESTIC_PASSWORD_IDENTITY" ]
then
  echo 'Cant find password, is RESTIC_PASSWORD_IDENTITY exported ? Exiting.';
  exit 2
fi

exec get-gopass.sh $RESTIC_PASSWORD_IDENTITY
