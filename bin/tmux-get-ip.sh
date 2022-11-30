#!/usr/bin/env bash

__route_str="$(ip route get 8.8.8.8 | head -1)";
if echo "${__route_str}" | /usr/bin/grep -q " via "
then
  __ip=$(echo "${__route_str}" | cut -d' ' -f7)
else
  __ip=$(echo "${__route_str}" | cut -d' ' -f5)
fi

__if=$(ip address show to "${__ip}" | head -1 | cut -f2 -d: | tr -d ' ' | cut -c1-2)

case "${__if}" in
  en|et)
    echo -n " "
    ;;
  wl)
    echo -n "直"
    ;;
  vp)
    echo -n " "
    ;;
  *)
    echo -n " ${__if} "
    ;;
esac


echo "${__ip}"
