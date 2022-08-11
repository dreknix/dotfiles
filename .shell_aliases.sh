#
# Shell aliases - read by .bashrc and .zshrc
#

## define common environment variables
export EDITOR='vim'
export PAGER='less'
# TODO
# export TERMINAL='st'

## storing dotfiles in git
#alias config='/usr/bin/git --git-dir=${HOME}/.cfg/ --work-tree=${HOME}'
config()
{
  if ! command -v git > /dev/null 2>&1
  then
    echo "Command git not found: apt install git"
    return
  fi
  if [ -z "$1" ]
  then
    config s
  else
    case "$1" in
      ls)
        if ! command -v tree > /dev/null 2>&1
        then
          config ls-files
        else
          config ls-files | tree --fromfile .
        fi
        ;;
      *)
        /usr/bin/env git --git-dir="${HOME}/.cfg/" --work-tree="${HOME}" "$@"
        ;;
    esac
  fi
}

## cd
if [ -n "${ZSH_NAME}" ]
then
  ### zsh specific aliases
  setopt autocd autopushd pushdignoredups
  alias d='dirs -v | head -n 10'
  alias 1='cd ~1'
  alias 2='cd ~2'
  alias 3='cd ~3'
  alias 4='cd ~4'
  alias 5='cd ~5'
  alias 6='cd ~6'
  alias 7='cd ~7'
  alias 8='cd ~8'
  alias 9='cd ~9'

  alias ...='../..'
  alias ....='../../..'
else
  ### bash specific aliases
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'
fi

## ls
alias ls='ls --color=auto'
alias ll='ls --color=auto -l'
alias l='ls --color=auto -lA'
# dircolors
eval "$(dircolors -b ~/.dir_colors)"

## less / man
# -X is needed for less version older than 530
# -X breaks the mouse-wheel
export LESS="-R --LONG-PROMPT -F -X"
# disable history of less
export LESSHISTFILE='-'
# color less for man
# LESS_TERMCAP_mb - begin blinking
# LESS_TERMCAP_md - begin bold
# LESS_TERMCAP_me - end mode
# LESS_TERMCAP_so - begin standout-mode - info box
# LESS_TERMCAP_se - end standout-mode
# LESS_TERMCAP_us - begin underline
# LESS_TERMCAP_ue - end underline
man() {
  LESS_TERMCAP_mb=$(printf "\e[5;34m")    \
  LESS_TERMCAP_md=$(printf "\e[1;34m")    \
  LESS_TERMCAP_me=$(printf "\e[0m")       \
  LESS_TERMCAP_so=$(printf "\e[7;49;32m") \
  LESS_TERMCAP_se=$(printf "\e[0m")       \
  LESS_TERMCAP_us=$(printf "\e[4;33m")    \
  LESS_TERMCAP_ue=$(printf "\e[0m")       \
  LESS="-R --LONG-PROMPT -F"              \
  command man "$@"
}

## bat
# -X is needed for less version older than 530
# -X breaks the mouse-wheel
export BAT_PAGER="-R --LONG-PROMPT -F -X"

## grep
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
export GREP_COLOR='1;32'

## diff
alias diff='diff --color=auto'

## dmesg
alias dmesg='dmesg --color=auto'

## iproute2
alias ip='ip -color=auto'
alias ipa='ip -brief -family inet address'
alias ipl='ip -brief link'
alias ipn='ip neighbor'
alias ipr='ip route'

# ps
alias psc='ps xawf -eo pid,user,cgroup,args'

## fzf - command-line fuzzy finder
#alias preview='fzf --height=50% --layout=reverse --preview="bat --color=always {}"'
alias preview='fzf --layout=reverse --preview="bat --color=always {}"'

## get external IP address
alias ip-address='curl -s -H "Accept: application/json" https://ipinfo.io/json | jq "del(.loc, .postal, .readme)"'

## nnn - terminal file manager
alias n='nnn -d'

## special commands
evince() {
  command evince "$@" >/dev/null 2>&1 &
}
okular() {
  command okular "$@" >/dev/null 2>&1 &
}

## gopass
getpw() {
  QUERY=$1
  if [ -z "$QUERY" ]
  then
    QUERY=''
  fi
  selected=$(gopass ls --flat | fzf -q "$QUERY")
  if [ -n "$selected" ]
  then
    if  grep -iq Microsoft /proc/version
    then
      gopass show --password "$selected" | clip.exe
    else
      gopass show --clip "$selected" > /dev/null 2>/dev/null
      # copy password also into the selction (Shift-Insert)
      xclip -out -selection clipboard | xclip -selection primary
    fi
  fi
}

## taskwarrior
alias t='taskwarrior rc:~/.taskrc_dreknix'

### open applications from prompt

if [ -x "${HOME}/bin/wsl-open.sh" ]
then
  alias wsl-open='wsl-open.sh'
  alias ii='wsl-open'
else
  alias ii='xdg-open'
fi

alias open='ii'

## ssh - do not remember
alias ssh_nr='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

## network stuff

# get the current netmask
alias netmask='ip -o -f inet addr show | awk "/scope global/ {print \$4}"'

# get all nodes in current network
alias scan_net='nmap -sn -oG - $(netmask)'

# get all nodes with ssh port in current network
alias scan_ssh='nmap -sV -p 22 -oG - $(netmask)'

