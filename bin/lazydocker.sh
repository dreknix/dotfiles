#!/usr/bin/env bash

# if podman is available use it
if command -v podman &> /dev/null
then
  if [ "$(uname -s)" = "Linux" ]
  then
    DOCKER_HOST="unix:///run/user/${UID}/podman/podman.sock" lazydocker
  else
    :
  fi
fi
