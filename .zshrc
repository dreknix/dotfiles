#!/usr/bin/env zsh

# profiling
# zmodload zsh/zprof

#
# .zshrc
#

# use https://github.com/jandedobbeleer/oh-my-posh

# speedup oh-my-posh
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

OHMYPOSH_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}/oh-my-posh"
eval "$(oh-my-posh init zsh --config ${OHMYPOSH_HOME}/dreknix.omp.yaml)"

# use https://github.com/zdharma-continuum/zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "${ZINIT_HOME}" ]
then
  mkdir -p "$(dirname ${ZINIT_HOME})"
  if [ ! -d "${ZINIT_HOME}/.git" ]
  then
    git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
  fi
fi
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit load atuinsh/atuin

### https://github.com/urbainvaes/fzf-marks
###
#
# ctrl-h - open fzf window with directories
#
FZF_MARKS_JUMP='^h'
FZF_MARKS_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/fzf-marks"
FZF_MARKS_FILE="${FZF_MARKS_DIR}/marks"
FZF_MARKS_COMMAND="fzf --tmux 70% --border=rounded --layout reverse --info=inline --preview='lsd --tree --depth 2 --group-dirs=first --color always --icon always {3..}' --preview-window=right,50%,rounded"
if [ ! -d "${FZF_MARKS_DIR}" ]
then
  mkdir "${FZF_MARKS_DIR}"
fi
zinit light urbainvaes/fzf-marks

### Last plugins in this order
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

### Load completions
###

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# add ~/.local/share/zsh-completions to $fpath
fpath=(${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/site-functions $fpath)
fpath+=~/.zfunc
autoload -Uz compinit
compinit -C

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
#setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# up/down arrow with partial history search
#bindkey 'OA' history-beginning-search-backward
#bindkey 'OB' history-beginning-search-forward

# Shell integrations
eval "$(fzf --zsh)"
export FZF_TMUX=1  # enable fzf-tmux

export _ZO_FZF_OPTS="--tmux 70% --delimiter=\t --nth=2 --read0 --exact --no-sort --cycle --border=rounded --keep-right --tabstop=1 --exit-0 --layout=reverse --info=inline --preview='ls -Cp --color=always --group-directories-first {2..}' --preview-window=down,30%,rounded"
eval "$(zoxide init --cmd cd zsh)"

source ~/.shell_common.sh
source ~/.shell_aliases.sh

### zsh completions

# in zsh aliases are expanded before completion
# therefore aliases to function starting with an '_' is not working
#setopt complete_aliases

## config - alias for dotfiles (git)
compdef config=git

## task
# task --completion zsh > ${XDG_DATA_HOME:-${HOME}/.local/share}/zsh-completions/_task

### end zsh completions

###
### keyboard shortcuts
###

### ctrl-g - open GitLab project in browser
function open_gitlab_project() {
  open_gitlab_project.sh
}
zle -N open_gitlab_project
bindkey '^g' open_gitlab_project

# opencode
export PATH=/home/dreknix/.opencode/bin:$PATH

# profiling
# zprof
