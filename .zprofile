
if [[ $(uname) == "Darwin" ]]
then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # needs: brew install keychain openssh
  eval "$(keychain --eval --agents ssh 2>/dev/null)"

  # for macOS - gopass and docker-credential-pass
  # needs: brew install gnupg
  # export GPG_TTY=$(tty)  # slower
  export GPG_TTY="${TTY}"
fi
