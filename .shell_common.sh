#!/usr/bin/env bash
#
# Shell common - read by .bashrc and .zshrc
#

# set umask (go-w)
umask 0022

# base16 shell
# see: https://github.com/chriskempson/base16-shell
BASE16_SHELL="${HOME}/.config/base16-shell/"
if [ -n "${PS1}" ]
then
  if [ -s "${BASE16_SHELL}/profile_helper.sh" ]
  then
    # shellcheck disable=SC1091
    . "${BASE16_SHELL}/profile_helper.sh"
  fi
fi

#
# config: nnn - file manager
#
BLK="03" CHR="03" DIR="04" EXE="02" REG="07" HARDLINK="05"
SYMLINK="05" MISSING="08" ORPHAN="01" FIFO="06" SOCK="03" UNKNOWN="01"

export NNN_COLORS="#04020301;4231"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$UNKNOWN"

export NNN_BMS="d:$HOME/Downloads;a:$HOME/dreknix/ansible;w:$HOME/dreknix/wiki"

export NNN_PLUG='p:preview-tui'

export NNN_BATTHEME='base16-256'

# run nnn with preview-tui plugin activated
alias n="nnn -a -P p"

# activate same graphical theme in Qt applications
export QT_STYLE_OVERRIDE=kvantum

# enable direnv if installed
if command -v direnv > /dev/null 2>&1
then
  if [ -n "${ZSH_NAME}" ]
  then
    eval "$(direnv hook zsh)"
  else
    eval "$(direnv hook bash)"
  fi
else
  if [ "$(expr substr $(uname -s) 1 6)" = "CYGWIN" ]
  then
  :
  #  if [ -x "/usr/local/bin/direnv.windows-amd64.exe" ]
  #  then
  #    alias direnv="/usr/local/bin/direnv.windows-amd64.exe"
  #    # not working under cygwin
  #    #if [ -n "${ZSH_NAME}" ]
  #    #then
  #    #  eval "$(direnv hook zsh)"
  #    #else
  #    #  eval "$(direnv hook bash)"
  #    #fi
  #  fi
  fi
fi

# enable del key in simple terminal (st)
case $TERM in
  st-*)
    tput smkx
    ;;
esac

export START_DIR_DIRS="${HOME}/dreknix ${HOME}/workspace"

# load local shell config
if [ -s "${HOME}/.shell_common_local.sh" ]
then
  # shellcheck disable=SC1091
  . "${HOME}/.shell_common_local.sh"
fi
