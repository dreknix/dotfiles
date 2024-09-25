#!/usr/bin/env zsh

#
# .zshenv
#

# set common profile settings and path
if [ -f "${HOME}/.profile_common.sh" ]
then
  . "${HOME}/.profile_common.sh"
fi

# Begin added by argcomplete
fpath=( /home/ti5cw/dreknix/ansible/.direnv/python-3.12/lib/python3.12/site-packages/argcomplete/bash_completion.d "${fpath[@]}" )
# End added by argcomplete
