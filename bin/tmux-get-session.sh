#!/usr/bin/env bash

# check for SSH 
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_TTY" ]; then
  echo -n " "
fi

# check for Windows
if grep -qi microsoft /proc/version
then
  echo -n " "
fi

case "$(grep -e '^ID=' /etc/os-release | cut -f 2 -d '=')" in
  ubuntu)
    echo -n " "
    ;;
  pop)
    echo -n " "
    ;;
  debian)
    echo -n " "
    ;;
  raspbian)
    echo -n " "
    ;;
  rhel)
    echo -n " "
    ;;
  *)
    echo -n " "
    ;;
esac

echo " $1($(tmux list-clients -t "$1" | wc -l))"
