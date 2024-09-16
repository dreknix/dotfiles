#!/usr/bin/env bash

#
# ~/.profile_common.sh
#

# add dart when available
if [ -d "/usr/lib/dart/bin" ]
then
  PATH="/usr/lib/dart/bin:${PATH}"
fi

# add rust when available
if [ -d "$HOME/.cargo/bin" ]
then
  PATH="$HOME/.cargo/bin:$PATH"
fi

# add go when available
if [ -d "${HOME}/go-workspace" ]
then
  export GOPATH="${HOME}/go-workspace"

  # add local scripts
  if [ -d "${GOPATH}/bin" ]
  then
    PATH="${GOPATH}/bin:${PATH}"
  fi
fi

# add local installed python programs
if [ -d "${HOME}/.local/bin" ]
then
  PATH="${HOME}/.local/bin:${PATH}"
fi

# add Poetry when available
if [ -d "${HOME}/.poetry/bin" ]
then
  PATH="${HOME}/.poetry/bin:${PATH}"
fi

# add local installed tools
if [ -d "${HOME}/bin-tools" ]
then
  PATH="${HOME}/bin-tools:${PATH}"
fi

# add local scripts
if [ -d "${HOME}/bin" ]
then
  PATH="${HOME}/bin:${PATH}"
fi

# load local profile settings and path
if [ -s "${HOME}/.profile_common_local.sh" ]
then
  # shellcheck disable=SC1091
  . "${HOME}/.profile_common_local.sh"
fi
