#!/usr/bin/env bash
#
# Shell aliases - read by .bashrc and .zshrc
#

## define common environment variables
if command -v nvim > /dev/null 2>&1
then
  export EDITOR='nvim'
  alias vi='nvim'
  alias vim='nvim'
elif command -v vim > /dev/null 2>&1
then
  export EDITOR='vim'
  alias vi='vim'
else
  export EDITOR='vi'
fi
if command -v less > /dev/null 2>&1
then
  export PAGER='less'
  alias more='less'
else
  export PAGER='more'
fi
# TODO
# export TERMINAL='st'

## storing dotfiles in git
# must be double quote for zsh completion
alias config="/usr/bin/git --git-dir=${HOME}/.cfg/ --work-tree=${HOME}"

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
if [ "$(less --version | grep -e '^less [0-9][0-9]* ' | cut -f2 -d' ')" -lt 590 ]
then
  # old versions of less have no option --use-color
  export LESS_BASIC_OPTS="\
    --RAW-CONTROL-CHARS \
    --LONG-PROMPT \
    --ignore-case \
    "
else
  export LESS_BASIC_OPTS="\
    --RAW-CONTROL-CHARS \
    --LONG-PROMPT \
    --ignore-case \
    --use-color \
    "
fi
export LESS="${LESS_BASIC_OPTS} --quit-if-one-screen"

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
  command man "$@"
}

# configure systemd and journalctl to use less with options
export SYSTEMD_PAGERSECURE="true"
export SYSTEMD_LESS="${LESS}"

## bat - https://github.com/sharkdp/bat
## A cat(1) clone with wings
if command -v bat > /dev/null 2>&1
then
  export BAT_CAT="bat"
else
  export BAT_CAT="batcat"
  alias bat="batcat"
fi
export BAT_PAGER="less ${LESS}"

## fd - https://github.com/sharkdp/fd
## A simple, fast and user-friendly alternative to find
if command -v fd > /dev/null 2>&1
then
  export FD_FIND="fd"
else
  export FD_FIND="fdfind"
  alias fd="fdfind"
fi

## grep
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
export GREP_COLORS='mt=1;32'

## ripgrep
if command -v rg > /dev/null 2>&1
then
  export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgrep/config"
  export FZF_DEFAULT_COMMAND="rg --files"
fi

## diff
alias diff='diff --color=auto'

## dmesg
alias dmesg='dmesg --color=auto'

## ps
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
#
# ctrl-up/down - scroll preview up/down
#
export FZF_DEFAULT_OPTS="\
  --tmux \
  --ansi \
  --multi \
  --layout=reverse \
  --border=rounded \
  --info=inline \
  --no-mouse \
  --cycle \
  --border \
  --margin=0,3,0,3 \
  --info=inline \
  "
  # --height=50% \

### fzf - git
#
# Available aliases
#  * xgcv   - view git log and copy/view commit
#
# xgcv - view git log and copy/view commit
__dreknix_xclip() {
  # remove \r in output, e.g. from Docker CLI commands
  tr -d '\r' | xclip -r -sel clipboard -filter | xclip -r -sel primary
}
__dreknix_xgcv() {
  git log \
    --color=always \
    --format="%C(cyan)%h %C(blue)%ar %C(yellow)%s %C(green)%ae" \
    "$@" | \
  fzf --exit-0 \
      --tiebreak=index \
      --preview="echo '{}' | \
                 grep -o '[a-f0-9]\{7\}' | \
                 head -1 | \
                 xargs -i sh -c 'git show --color=always {} |
                 delta'" \
      --header "enter: view, C-c: copy hash, escape: exit fzf" \
      --bind "enter:execute(echo '{}' | \
                            grep -o '[a-f0-9]\{7\}' | \
                            head -1 | \
                            xargs -i sh -c 'LESS=${LESS_BASIC_OPTS} \
                              git show --color=always {} | \
                              delta --paging=always > /dev/tty' \
                           )" \
      --bind "ctrl-c:execute(echo '{}' | \
                             grep -o '[a-f0-9]\{7\}' | \
                             head -1 | \
                             tr -d '\n' | \
                             xclip -i -sel clipboard -filter | \
                             xclip -i -sel primary \
                            )"
}
alias xgcv=__dreknix_xgcv

### fzf - Docker
#
# Available aliases:
#  * xdci   - inspect container
#  * xdcip  - get container IP
#  * xdcr   - remove containers
#  * xdcs   - stop containers
#  * xdctxc - change to context
#  * xdctxi - inspect context
#  * xdctxr - remove contexts
#  * xdii   - inspect image
#  * xdir   - remove images
#  * xdni   - inspect network
#  * xdnr   - remove networks
#  * xdrc   - run an image as container
#  * xdri   - run a shell inside a container
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
# Docker container IP
__xdcip() {
  __container="$(__xdc_base | \
    fzf --header-lines=1 | \
    awk '{print $3}')"
  if [ -n "${__container}" ]
  then
    __network="$(docker inspect "${__container}" -f '{{.NetworkSettings.Networks}}' | \
                 awk -F 'map\\[|:' '{print $2}')"
    history -s docker inspect -f "{{.NetworkSettings.Networks.${__network}.IPAddress}}" "${__container}"
    docker inspect -f "{{.NetworkSettings.Networks.${__network}.IPAddress}}" "${__container}"
  fi
}
alias xdcip=__xdcip
# Docker container remove
__xdcr() {
  __xdc_base | \
    fzf --multi --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty docker container rm --force --volumes
}
alias xdcr=__xdcr
# Docker container stop
__xdcs() {
  __xdc_base | \
    fzf --multi --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty docker container stop
}
alias xdcs=__xdcs
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
# Docker run image as container
__xdrc() {
  __xdi_base | \
    fzf --header-lines=1 | \
    awk '{print $3}' | \
    xargs --no-run-if-empty --open-tty docker run -it --rm
}
alias xdrc=__xdrc
# Docker run command in container
__xdri() {
  __container="$(__xdc_base | \
                 fzf --header-lines=1 | \
                 awk '{print $3}')"
  if [ -n "${__container}" ]
  then
    printf "\n   \033[92mDocker container:\033[93m %s\n" "${__container}"
    printf "   \033[92mOptions: \033[93m"
    read -r -e -p "" -i "-it" __options
    printf "   \033[92mCommand: \033[93m"
    read -r -e -i "/bin/sh" __cmd
    printf "\033[0m\n"
    history -s xdri # must be set due to next 'history -s'
    # shellcheck disable=SC2086
    history -s docker exec ${__options} ${__container} ${__cmd}
    # shellcheck disable=SC2086
    docker exec ${__options} ${__container} ${__cmd}
    echo ''
  fi
}
alias xdri=__xdri
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

### fzf - General aliases
#
# Available aliases:
# * v - start vi with previous file selection
# * xcd - fast switch to directory
# * xgrep - advanced grep with ripgrep and fzf
# * xhistory - fzf history selection
# * xpkill - kill processes
# * xpreview - preview files and start editor
# * xssh - ssh to host
# * xtv - start vi in tmux in new directory
# * xvi - preview files and start editor (stay in preview)
#
# v - start vi with previous file selection
_v() {
  local find_cmd=()
  if [ -n "${FD_FIND}" ]
  then
    find_cmd=("${FD_FIND}" "--type" "f" "--hidden" "--exclude" ".git")
  else
    find_cmd=("find" "." "-type" "f" "-not" "-path" "'*/.git/*'" "-not" "-path" "'*/.direnv/*'")
  fi
  "${find_cmd[@]}" | \
      fzf-tmux -p | \
      xargs --no-run-if-empty --open-tty "${EDITOR}"
}
alias v=_v
# xcd - fast switch to directory
__xcd() {
  if [ -n "${FD_FIND}" ]
  then
    cd "$("${FD_FIND}" --type d . "${HOME}" | fzf -1)" || return
  else
    cd "$(find "${HOME}" -type d | fzf -1)" || return
  fi
}
alias xcd=__xcd
# xtv - start vi in tmux in new directory
__xtv() {
  local __dir __target
  if [ -n "${FD_FIND}" ]
  then
    __dir="$("${FD_FIND}" --type d . "${HOME}" | fzf -1)"
  else
    __dir="$(find "${HOME}" -type d | fzf -1)"
  fi
  if [ -n "${__dir}" ]
  then
    __target="$(basename "${__dir}")"
    if [ "$TERM_PROGRAM" = tmux ]
    then
      echo tmux new-window -c "${__dir}" -n "${__target}"
      tmux new-window -c "${__dir}" -n "${__target}"
      tmux send-keys -t ':.' "${EDITOR}" ENTER
    else
      tmux new-session -d -c "${__dir}" -n "${__target}"
      tmux send-keys -t ':.' "${EDITOR}" ENTER
      tmux attach-session -t ":"
    fi
  fi
}
alias xtv=__xtv
# xpkill - kill processes
__xpkill() {
  ps -o 'pid,ppid,user,%cpu,%mem,etime,cmd' -U "$(id -u)" | \
   fzf --multi --header-lines=1 | \
   xargs --no-run-if-empty kill -9
}
alias xpkill=__xpkill
# xpreview - preview files and start editor
__xpreview() {
  fzf --preview="${BAT_CAT} --color=always {}" | \
    xargs --no-run-if-empty --open-tty "${EDITOR}"
}
alias xpreview=__xpreview
# xvi - preview files and start editor (stay in preview)
__xvi() {
  fzf --preview="${BAT_CAT} --color=always {}" \
      --bind "enter:execute(${EDITOR} {})"
}
alias xvi=__xvi
# xssh - ssh to host
__xssh() {
   ( \
     awk '!/\*/ && /^Host /{print $2}' ~/.ssh/config.d/*; \
     awk '{sub(",.*$","",$1);print $1}' ~/.ssh/known_hosts*; \
   ) | \
   grep -v '?' | \
   grep -e "\.[a-z]\+$" | \
   sort -u | \
   fzf | \
   xargs --no-run-if-empty --open-tty ssh
}
alias xssh=__xssh
# xhistory - fzf history selection
# the history is empty during execution, so history commands
# will not work, when selected in fzf
__dreknix_xhistory() {
   history | \
     fzf --tac | \
     sed 's/^[ ]*[0-9]\+[ ]*//' | \
     "${SHELL}"
}
alias xhistory=__dreknix_xhistory
# xgrep - advanced grep with ripgrep and fzf
#
# based on: https://fossies.org/linux/fzf/ADVANCED.md
# if fzf version is > 0.3 a better version can be used
#
# Alt-Enter: switch from ripgrep to fzf
#
__dreknix_xgrep() {
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="${*:-}"
  # shellcheck disable=SC2016
  IFS=: read -ra selected < <(
    FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
    fzf --ansi \
        --height=100% \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --disabled --query "$INITIAL_QUERY" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind "alt-enter:unbind(change,alt-enter)+change-prompt(2. fzf> )+enable-search+clear-query" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --preview '${BAT_CAT} --color=always {1} --highlight-line {2}' \
        --preview-window 'right,60%,border-bottom,+{2}+3/3'
  )
  [ -n "${selected[0]}" ] && "${EDITOR}" "${selected[0]}" "+${selected[1]}"
}
alias xgrep=__dreknix_xgrep
##
## end of fzf
##

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

## kubectl
alias k='kubectl'

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

## pet - command-line environment and snippet manager
## https://github.com/knqyf263/pet

# convert a previous command from history into a snippet
function prev() {
  PREV="$(history | \
    fzf --tac | \
    sed 's/^[ ]*[0-9]\+[ ]*//')"
  if [ -n "${PREV}" ]
  then
    pet new "${PREV}"
  fi
}

# select a snippet and copy it in the command line
function bash_pet_select() {
  BUFFER=$(pet search --query "$READLINE_LINE")
  READLINE_LINE=$BUFFER
  READLINE_POINT=${#BUFFER}
}
function zsh_pet_select() {
  # shellcheck disable=SC2153
  BUFFER=$(pet search --query "$LBUFFER")
  # shellcheck disable=SC2034
  CURSOR=$#BUFFER
  zle redisplay
}
if [ -z "${ZSH_NAME}" ]
then
  ### bash
  bind -x '"\C-x\C-r": bash_pet_select'
else
  ### zsh
  zle -N zsh_pet_select
  stty -ixon
  bindkey "^s" zsh_pet_select
fi

# select a snippet and copy it in the clipboard
function bash_pet_xcopy() {
  pet search --query "$READLINE_LINE" | __dreknix_xclip
  # reset search string in current line
  READLINE_LINE=""
  READLINE_POINT=0
}
if [ -z "${ZSH_NAME}" ]
then
  ### bash
  bind -x '"\C-x\C-x": bash_pet_xcopy'
fi


##
## network stuff
##

# iproute2
alias ip='ip -color=auto'
alias ipa='ip -brief -family inet address'
alias ipl='ip -brief link'
alias ipn='ip neighbor'
alias ipr='ip route'

# get public IP address
__net_public_ip() {
  curl -s -H "Accept: application/json" https://ipinfo.io/json | \
    jq "del(.loc, .postal, .readme)"
}
alias net-public-ip=__net_public_ip

# get primary IP address
alias net-public-ip=__net_public_ip
__net_ip() {
  # $ ip route get 8.8.8.8 | head -1
  # 8.8.8.8 via x.x.x.x dev device src x.x.x.x uid yyyy
  # or
  # 8.8.8.8 dev device src x.x.x.x uid yyyy
  __route_str="$(ip route get 8.8.8.8 | head -1)"
  if echo "${__route_str}" | grep -q " via "
  then
    echo "${__route_str}" | cut -d' ' -f7
  else
    echo "${__route_str}" | cut -d' ' -f5
  fi
}
alias net-ip=__net_ip

# get the current netmask
__net_netmask() {
  ip -o -f inet addr show | \
    grep "$(net-ip)" | \
    awk '/scope global/ {print $4}'
}
alias net-netmask=__net_netmask

# get all nodes in current network
__net_scan() {
  nmap -sn -oG - "$(net-netmask)" | \
    grep -v "^#" | \
    fzf --multi | \
    awk '{print $2}' | \
    xargs --no-run-if-empty nmap -A -sV
}
alias net-scan=__net_scan

# get all nodes with ssh port in current network
alias net-scan-ssh='nmap -sV -p 22 -oG - $(net-netmask)'
