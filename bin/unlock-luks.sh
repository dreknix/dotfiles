#!/usr/bin/env bash

set -e
# set -v -x

if [ "$#" -ne 1 ]
then
  echo "usage: $0 hostname"
  exit 1
fi

fqdn=$(host "$1" 2>/dev/null| grep "has address" | awk '{print $1}')

if [ -z "${fqdn}" ]
then
  echo "$0: hostname '$1' not valid"
  exit 2
fi

luks_pass="$(get-gopass.sh "${fqdn}"/luks)"

if [ -z "${luks_pass}" ]
then
  echo "$0: host '$1' has no configured LUKS password"
  exit 3
fi

echo -n "${luks_pass}" | ssh "luks-${fqdn}" "cryptroot-unlock"
