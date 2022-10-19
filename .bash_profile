# .bash_profile
# gets evaluated: console login, ssh login, tmux new pane or window, ...
#

# start SSH agent if not already running
# ignore SSH connections and sudo shells as tmux session
if [ -z "${TMUX}" ] && [ -z "${SSH_CONNECTION}" ] && [ -z "${SUDO_USER}" ] && [ -z "${SSH_AGENT_PID}" ]
then
  UNAMEOUT="$(uname -s)"
  # under cygwin each terminal is started separately
  # so we need to check if a ssh-agent ist running
  # in a different fashion
  case "${UNAMEOUT}" in
    CYGWIN*)
      # use aliases ssh -> ssh.exe in order to use Windows ssh-agent
      echo "using existing Windows SSH agent"
      ;;
    *)
      . .ssh-agent.conf > /dev/null 2>&1
      if ps -p "${SSH_AGENT_PID}" > /dev/null 2>&1
      then
        echo "using existing SSH agent ${SSH_AGENT_PID}"
      else
        ssh-agent > .ssh-agent.conf
        . .ssh-agent.conf
      fi
      ;;
  esac
fi

start_gpg_agent=false

## start gpg-agent (under WSL2)
if grep -iq Microsoft /proc/version 2>/dev/null
then
  start_gpg_agent=true
fi

if [ -n "$(which getprop 2>/dev/null)" ]
then
  start_gpg_agent=true
fi

if "$start_gpg_agent"
then
  # Start gpg-agent, if not running already
  pgrep gpg-agent > /dev/null || eval "$(gpg-agent --daemon)"
  GPG_TTY=$(tty)
  export GPG_TTY
  GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket | tr -d '\n' && echo -n ::)
  export GPG_AGENT_INFO
fi

# add dart when available
if [ -d "/usr/lib/dart/bin" ]
then
  PATH="/usr/lib/dart/bin:${PATH}"
fi

# add rust when available
if [ -d "$HOME/.cargo/bin" ]
then
  PATH="$HOME/.cargo/bin:$PATH"
fi

# add go when available
if [ -d "${HOME}/go-workspace" ]
then
  export GOPATH=${HOME}/go-workspace

  # add local scripts
  if [ -d "${GOPATH}/bin" ]
  then
    PATH="${GOPATH}/bin:${PATH}"
  fi
fi

# add local installed python programs
if [ -d "${HOME}/.local/bin" ]
then
  PATH="${HOME}/.local/bin:${PATH}"
fi

# add Poetry when available
if [ -d "${HOME}/.poetry/bin" ]
then
  PATH="${HOME}/.poetry/bin:${PATH}"
fi

# add local scripts
if [ -d "${HOME}/bin" ]
then
  PATH="${HOME}/bin:${PATH}"
fi

# do some cygwin specific configs
case "${UNAMEOUT}" in
  CYGWIN*)
    # check if under cygwin MiKTeX is available
    if [ -x /cygdrive/c/Program\ Files/MiKTeX*/miktex/bin/*/pdflatex ]
    then
      miktex=$(dirname /cygdrive/c/Program\ Files/MiKTeX*/miktex/bin/*/pdflatex)
      export PATH="${miktex}:${PATH}"
    fi

    # use ssh from Windows OpenSSH
    if [ -x /cygdrive/c/Windows/System32/OpenSSH/ssh.exe ]
    then
      export PATH="/cygdrive/c/Windows/System32/OpenSSH:${PATH}"
    fi
    alias ssh="ssh.exe"
    alias ssh-agent="ssh-agent.exe"
    alias ssh-add="ssh-add.exe"

    # # check if under cygwin Java is available
    # if [ -x /cygdrive/c/tools/*jdk-*/bin/javac ]
    # then
    #   java=$(dirname /cygdrive/c/tools/*jdk-*/bin/javac)
    #   export PATH="${java}:${PATH}"
    # fi

    # # add non cgwin cli tools to PATH
    # if [ -d "/cygdrive/c/tools/bin" ]
    # then
    #   export PATH="/cygdrive/c/tools/bin:${PATH}"
    # fi

    # remove GIT_SSH environment variable (used by Git for Windows)
    if [ -n "${GIT_SSH}" ]
    then
      unset GIT_SSH
    fi
    ;;
esac

# only if not sourced by .profile
if [ -z "${commingFromProfile}" ]
then
  # if running bash, source the ~/.bashrc
  if [ -n "$BASH_VERSION" ]
  then
    # include .bashrc if it exists
    if [ -f "${HOME}/.bashrc" ]
    then
      . "${HOME}/.bashrc"
    fi
  fi
fi

## on android (termux) start the shell in chroot environment
#if [ ! -z "`which termux-chroot 2>&1`" ] && [ ! -d "/usr/bin" ]
#then
#  termux-chroot
#  exit
#fi
