#
# Shell aliases - read by .bashrc and .zshrc
#

## define common environment variables
if command -v vim > /dev/null 2>&1
then
  export EDITOR='vim'
else
  export EDITOR='vi'
fi
if command -v less > /dev/null 2>&1
then
  export PAGER='less'
else
  export PAGER='more'
fi
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
# on Ubuntu bat is renamed as batcat
if command -v batcat > /dev/null 2>&1
then
  export BAT_CAT="batcat"
  alias bat="batcat"
else
  export BAT_CAT="bat"
fi

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

## jq - JSON processor
__json_processor() {
  if command -v jq > /dev/null 2>&1
  then
    jq --color-output
  else
    cat
  fi
}

##
## fzf - command-line fuzzy finder
##
export FZF_DEFAULT_OPTS="\
  --ansi \
  --multi \
  --layout=reverse \
  --inline-info \
  --no-mouse \
  --cycle \
  --height=50% \
  --border \
  --margin=0,3,0,3 \
  --info=inline \
  "

### fzf - Docker
#
# Available aliases:
#  * xdci   - inspect container
#  * xdcr   - remove containers
#  * xdctxc - change to context
#  * xdctxi - inspect context
#  * xdctxr - remove contexts
#  * xdii   - inspect image
#  * xdir   - remove images
#  * xdni   - inspect network
#  * xdnr   - remove networks
#  * xds    - search images in Docker hub
#  * xdst   - search image tags Docker hub
#  * xdsi   - system info
#  * xdvi   - inspect volume
#  * xdvr   - remove volumes
#
# Extend information about available table columns:
# $ docker container ls -a --format "{{json .}}" | jq
#
# Docker container base
__xdc_base() {
  __FSTR="{{.Image}}\t{{.Command}}\t{{.ID}}\t{{.Names}}\t{{.Status}}"
  docker container ls -a --format "table ${__FSTR}"
}
# Docker container inspect
__xdci() {
  __xdc_base | \
    fzf --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty docker container inspect | \
    __json_processor | "${PAGER}"
}
alias xdci=__xdci
# Docker container remove
__xdcr() {
  __xdc_base | \
    fzf --multi --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty docker container rm --force --volumes
}
alias xdcr=__xdcr
# Docker context base
__xdctx_base() {
  __FSTR="{{.Current}}\t{{.Name}}\t{{.Description}}\t{{.DockerEndpoint}}\t{{.KubernetesEndpoint}}"
  docker context ls --format "table ${__FSTR}"
}
# Docker context change
__xdctxc() {
  __xdctx_base | \
    fzf --header-lines=1 | \
    awk '{print $2}' | \
    xargs --no-run-if-empty docker context use
}
alias xdctxc=__xdctxc
# Docker context inspect
__xdctxi() {
  __xdctx_base | \
    fzf --header-lines=1 | \
    awk '{print $2}' | \
    xargs --no-run-if-empty docker context inspect | \
    __json_processor | "${PAGER}"
}
alias xdctxi=__xdctxi
# Docker context remove - dont use force here
__xdctxr() {
  __xdctx_base | \
    fzf --multi --header-lines=1 | \
    awk '{print $2}' | \
    xargs --no-run-if-empty docker context rm
}
alias xdctxr=__xdctxr
# Docker image base
__xdi_base() {
  __FSTR="{{.Repository}}\t{{.Containers}}\t{{.ID}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"
  docker image ls --format "table ${__FSTR}"
}
# Docker image inspect
__xdii() {
  __xdi_base | \
    fzf --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty docker image inspect | \
    __json_processor | "${PAGER}"
}
alias xdii=__xdii
# Docker image remove
__xdir() {
  __xdi_base | \
    fzf --multi --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty docker image rm --force
}
# Docker network base
__xdn_base() {
  __FSTR="{{.Driver}}\t{{.Scope}}\t{{.ID}}\t{{.Name}}\t{{.Internal}}\t{{IPv6}}"
  docker network ls --format "table ${__FSTR}"
}
# Docker network inspect
__xdni() {
  __xdn_base | \
    fzf --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty docker network inspect | \
    __json_processor | "${PAGER}"
}
alias xdni=__xdni
# Docker network remove - do not use force here
__xdnr() {
  __xdn_base | \
    fzf --multi --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty docker network rm
}
alias xdnr=__xdnr
# Docker search hub for tags
__xdst() {
  if [ $# -ne 1 ]
  then
    echo "Search Docker hub: xdst image"
  else
    curl -L -s "https://registry.hub.docker.com/v2/repositories/library/$1/tags?page_size=1024" |\
      jq -r '.results|=sort_by(.last_updated) | .results[].name' | \
      tac | fzf | \
      xargs --no-run-if-empty -i echo "$1:{}"
  fi
}
alias xdst=__xdst
# Docker search hub
__xds() {
  if [ $# -ne 1 ]
  then
    echo "Search Docker hub: xds image"
  else
    __FSTR="{{.Name}}\t{{.Description}}\t{{.StarCount}}\t{{.IsOfficial}}"
    docker search --format "table ${__FSTR}" "$1" | \
      fzf --header-lines=1 | \
      awk '{print $1}'
  fi
}
alias xds=__xds
# Docker system info
alias xdsi='docker system info --format "{{json .}}" | __json_processor | "${PAGER}"'
# Docker volume base
__xdv_base() {
  __FSTR="{{.Driver}}\t{{.Scope}}\t{{.Name}}\t{{.Mountpoint}}"
  docker volume ls --format "table ${__FSTR}"
}
# Docker volume inspect
__xdvi() {
  __xdv_base | \
    fzf --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty docker volume inspect | \
    __json_processor | "${PAGER}"
}
alias xdvi=__xdvi
# Docker volume remove - do not use force here
__xdvr() {
  __xdv_base | \
    fzf --multi --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty docker volume rm
}
alias xdvr=__xdvr
### general fzf aliases
# fast switch to directory
__xcd() {
  if command -v fdfind > /dev/null 2>&1
  then
    cd "$(fdfind --type d . "${HOME}" | fzf -1)" || return
  else
    cd "$(find "${HOME}" -type d | fzf -1)" || return
  fi
}
alias xcd=__xcd
# kill processes
__xpkill() {
  ps -o 'pid,ppid,user,%cpu,%mem,etime,cmd' -U "$(id -u)" | \
   fzf --multi --header-lines=1 | \
   xargs --no-run-if-empty kill -9
}
alias xpkill=__xpkill
# preview files and start editor
__xpreview() {
  fzf --preview="${BAT_CAT} --color=always {}" | \
    xargs --no-run-if-empty --open-tty "${EDITOR}"
}
alias xpreview=__xpreview
# preview files and start editor (stay in preview)
__xvi() {
  fzf --bind '?:preview:"${BAT_CAT}" --color=always {}' \
      --preview-window hidden \
      --bind "enter:execute(vim {})"
}
alias xvi=__xvi
##
## end of fzf
##

## get external IP address
__ip_address() {
  curl -s -H "Accept: application/json" https://ipinfo.io/json | \
    jq "del(.loc, .postal, .readme)"
}
alias ip-address=__ip_address

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

### open/ii - open applications from prompt
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
alias netmask="ip -o -f inet addr show | awk '/scope global/ {print \$4}'"

# get all nodes in current network
alias scan_net='nmap -sn -oG - $(netmask)'

# get all nodes with ssh port in current network
alias scan_ssh='nmap -sV -p 22 -oG - $(netmask)'

