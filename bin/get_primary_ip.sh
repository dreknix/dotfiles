#!/usr/bin/env bash

case "$(uname -s)" in
  Darwin*)
    interface="$(route -n get 1.1 2> /dev/null | awk '/interface: /{print $2}')"
    ifconfig "${interface}" | awk '/inet/{print $2}'
    ;;
  *)
    route_str="$(ip route get 1.1 2> /dev/null | head -1)"
    echo "${route_str}" | awk '{for (i=1; i<NF; i++) if ($i == "src") {print $(i+1); break}}'
    ;;
esac
