#
case $TERM in
  xterm*)
    precmd () {print -Pn "\e]0;$USER@$HOST:${PWD/$HOME/~}\a"}
    ;;
esac

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Set up history
setopt histignorealldups histignorespace sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100
SAVEHIST=100
HISTFILE=~/.zsh_history

# set common settings and color
if [ -f "${HOME}/.shell_common.sh" ]
then
  . "${HOME}/.shell_common.sh"
fi

### Source zinit (plugin manager)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"
### end zinit

### Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

### Auto suggestions
zinit light zsh-users/zsh-autosuggestions
# chang color for solarized dark
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
# word wise accepting of suggestion
bindkey "^[[1;5C" forward-word   # Ctrl + right arrow
bindkey "^[[1;5D" backward-word  # Ctrl + left arrow

### Syntax highlighting
#switch from zsh-users to zdharma-continuum
#zinit load zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting

# Use modern completion system
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
compinit -i

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# define common aliases, wrapper and environment variables
if [ -f "${HOME}/.shell_aliases.sh" ]
then
  . "${HOME}/.shell_aliases.sh"
fi

