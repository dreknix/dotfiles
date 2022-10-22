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
    source "${BASE16_SHELL}/profile_helper.sh"
  fi
fi

# activate same graphical theme in Qt applications
export QT_STYLE_OVERRIDE=kvantum

# enable direnv if installed
if type -p direnv > /dev/null 2>&1
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

# load local shell config
if [ -s "${HOME}/.shell_common_local.sh" ]
then
  # shellcheck disable=SC1091
  source "${HOME}/.shell_common_local.sh"
fi
