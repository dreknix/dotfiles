# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Whenever displaying the prompt, write the previous line to disk:
PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"

# Ignore some commands from my history. No need to remember the exit command
export HISTIGNORE="&:[ ]*:[bf]g:history:clear:exit"

# Save multi-line commands to the history as one command
shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=5000

# not working with 'history -a; history -c; history -r'
# HISTTIMEFORMAT="%F %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#
# Set and configure the prompt PS1
PROMPT_COMMAND="__prompt_command; ${PROMPT_COMMAND}" # func to generate PS1 after CMDs

# show only the last three directories in prompt
export PROMPT_DIRTRIM=3

function __we_are_in_git_working_tree() {
  git rev-parse --is-inside-work-tree &> /dev/null
}

function __parse_git_branch() {
  local BR
  BR="$(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2> /dev/null)"
  if [ "$BR" == HEAD ]
  then
    local NM
    NM=$(git name-rev --name-only HEAD 2> /dev/null)
    if [ "$NM" != undefined ]
    then
      echo -n "@$NM"
    else
      git rev-parse --short HEAD 2> /dev/null
    fi
  else
    echo -n "$BR"
  fi
}

function __git_info() {
  hash git 2>/dev/null || return # git not found
  local git_eng="env LANG=C git" # force git output in English to make our work easier

  readonly SYMBOL_GIT_PUSH='↑'
  readonly SYMBOL_GIT_PULL='↓'
  readonly SYMBOL_GIT_MODIFIED='*'

  if __we_are_in_git_working_tree
  then
    local marks

    # scan first two lines of output from `git status`
    while IFS= read -r line; do
      if [[ $line =~ ^## ]]
      then # header line
        [[ $line =~ ahead\ ([0-9]+) ]] && marks+="$SYMBOL_GIT_PUSH${BASH_REMATCH[1]}"
        [[ $line =~ behind\ ([0-9]+) ]] && marks+="$SYMBOL_GIT_PULL${BASH_REMATCH[1]}"
      else # branch is modified if output contains more lines after the header line
        marks="$SYMBOL_GIT_MODIFIED$marks"
        break
      fi
    done < <($git_eng status --porcelain --branch 2>/dev/null)  # note the space between the two <

    # print the git branch segment without a trailing newline
    printf '%s' "$ref$marks"
  fi
}

function __prompt_command() {
  local EXIT="$?" # first store return value of last command

  case $TERM in
    *xterm*|rxvt*|st*)
      PS1='\[\e]0;\u@\h: \w\a\]'
      ;;
    *)
      PS1=''
      ;;
  esac

  #
  # color 48;5;1;38;5;19m - bg 1 and fg 19
  #
  PS1+='\n' # start with a newline
  if [ -n "${SSH_CONNECTION}" ]
  then
    PS1+='\[\e[48;5;1;38;5;19m\] SSH \[\e[m\]\[\e[48;5;19;38;5;1m\]'
  fi
  #PS1+='\[\e[48;5;19;1;38;5;14m\] ' # bold
  PS1+='\[\e[48;5;19;38;5;14m\] '
  # check if running in termux (Android)
  if [ -n "$(which getprop 2>/dev/null)" ]
  then
    # running in termux (Android)
    USER="dreknix"
    HOSTNAME="$(getprop ro.product.model | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]]//g')"
    PS1+='${USER}@${HOSTNAME}:\w'
  else
    # running in everywhere else
    PS1+='\u@\h:\w'
  fi

  if __we_are_in_git_working_tree
  then
    PS1+='\[\e[48;5;19;38;5;20m\]  \[\e[48;5;19;38;5;11m\]'
    PS1+='(`__parse_git_branch`)`__git_info`'
  fi
  PS1+=' \[\e[m\]\[\e[38;5;19m\]'

  PS1+='\[\e[m\]\n' # newline and resetting color before

  # TODO: do something when user is root
  if [ "${USER}" == "root" ]
  then
    :
  fi

  local errSymbol='❯'
  if [ ${EXIT} != 0 ]
  then
    local errFG='1;38;5;9m'  # bold color (1) fg 9
  else
    local errFG='1;38;5;10m' # bold color (1) fg 10
  fi
  PS1+=' \[\e['${errFG}'\]'${errSymbol}'\[\e[m\] '
}

# disable the use of `/etc/hots` for bash completion
export COMP_KNOWN_HOSTS_WITH_HOSTFILE=""

# set common settings and color
if [ -f "${HOME}/.shell_common.sh" ]
then
  . "${HOME}/.shell_common.sh"
fi

# define common aliases, wrapper and enviroment variables
if [ -f "${HOME}/.shell_aliases.sh" ]
then
  . "${HOME}/.shell_aliases.sh"
fi

# Adding bash completion as last step
if [ -z "$(complete -p)" ]
then
  if ! shopt -oq posix
  then
    if [ -f /usr/share/bash-completion/bash_completion ]
    then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]
    then
      . /etc/bash_completion
    fi
  fi
fi

# check if starship is installed
if [ -x "${HOME}/bin/starship" ]
then
  eval "$(starship init bash)"
fi
