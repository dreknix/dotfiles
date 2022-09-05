#!/usr/bin/env bash

set -e
# set -v -x

id="$ANSIBLE_VAULT_IDENTITY"
path="${id}/ansible/vault"

# disable gopass notifications
export GOPASS_NO_NOTIFY=false

gopass ls --flat | grep -iq "^${path}$" || \
  ( echo 'Cant find password, is ANSIBLE_VAULT_IDENTITY exported ? Exiting.';
  exit 3)

# gopass must be so configured that only the password is printed
gopass show --force --password "${path}"
