#
# Shell common - read by .bashrc and .zshrc
#

# set umask (go-w)
umask 0022

# base16 shell
# see: https://github.com/chriskempson/base16-shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
  [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
    eval "$("$BASE16_SHELL/profile_helper.sh")"

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
if [ -f "$HOME/.shell_common_local.sh" ]
then
  . "$HOME/.shell_common_local.sh"
fi
