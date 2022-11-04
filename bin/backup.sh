#!/usr/bin/env bash

# USB stick
export RESTIC_USB_STICK="/media/${USER}/Restic"
# repository
HOST_NAME="$(hostname -f)"
export RESTIC_REPOSITORY="${RESTIC_USB_STICK}/${HOST_NAME}"
# command to extract the passphrase for the repository
export RESTIC_PASSWORD_COMMAND="get-restic-pw-from-gopass.sh"
# identity for the repository passphrase
export RESTIC_PASSWORD_IDENTITY="dreknix/restic/samsung-t7"

if [ ! -f "${RESTIC_USB_STICK}/.dreknix" ]
then
  echo "USB stick for restic is missing"
  exit 1
fi

if ! command -v "${RESTIC_PASSWORD_COMMAND}" &> /dev/null
then
  echo "Get password from gopass is missing"
  exit 1
fi

if ! command -v restic &> /dev/null
then
  echo "The tool restic is missing"
  exit 1
fi

if [ ! -d "${RESTIC_REPOSITORY}" ]
then
  echo "Initialize repository: ${RESTIC_REPOSITORY}"
  restic init
fi

# check if repository is ok
restic check -q

echo ""
echo "Creating backup of ${HOME}"
restic backup "${HOME}" \
  --exclude="${HOME}/*" \
  --exclude="!${HOME}/Desktop" \
  --exclude="!${HOME}/dreknix" \
  --exclude="!${HOME}/workspace" \
  --exclude="build" \
  --exclude="__pycache__" \
  --exclude=".git" \
  --exclude=".svn" \
  --exclude=".direnv" \
  --exclude="*.o" \
  --exclude-larger-than 100M

echo ""
echo "Show diff to last backup"
restic diff --quiet $(restic snapshots --json | jq -r '.[-2:][].id')

echo ""
echo "Expire old snapshots"
restic forget \
    --quiet \
    --prune \
    --keep-daily   7 \
    --keep-weekly  8 \
    --keep-monthly 12 \
    --keep-yearly  2

echo ""
echo "Show snapshots"
restic snapshots --quiet --compact

echo ""
echo "Show stats"
restic stats --quiet --mode raw-data

