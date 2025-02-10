#!/usr/bin/env zsh

#
# .zshrc
#

# use https://github.com/jandedobbeleer/oh-my-posh
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
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

### https://github.com/urbainvaes/fzf-marks
###
#
# ctrl-g - open fzf window with directories
#
FZF_MARKS_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/fzf-marks"
FZF_MARKS_FILE="${FZF_MARKS_DIR}/marks"
FZF_MARKS_COMMAND="fzf --tmux 70% --border=rounded --layout reverse --info=inline --preview='lsd --tree --depth 2 --group-dirs=first --color always --icon always {3..}' --preview-window=right,50%,rounded"
if [ ! -d "${FZF_MARKS_DIR}" ]
then
  mkdir "${FZF_MARKS_DIR}"
fi
zinit light urbainvaes/fzf-marks

### Load completions
###

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# If you're using tmux >= 3.2, we provide a script ftb-tmux-popup to make full use of it's "popup" feature.
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-min-size 60 2

# add ~/.local/share/zsh-completions to $fpath
fpath=(${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/site-functions $fpath)
autoload -Uz compinit && compinit

zinit light Aloxaf/fzf-tab

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# up/down arrow with partial history search
bindkey 'OA' history-beginning-search-backward
bindkey 'OB' history-beginning-search-forward

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
