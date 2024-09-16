#!/usr/bin/env zsh

#
# .zprofile
#

# set common profile settings and path
if [ -f "${HOME}/.profile_common.sh" ]
then
  . "${HOME}/.profile_common.sh"
fi
