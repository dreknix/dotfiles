#!/usr/bin/env bash

__route_str="$(ip route get 8.8.8.8 | head -1)";
if [ -z "${__route_str}" ]
then
  # currently no internet
  __if="NONE"
else
  if echo "${__route_str}" | /usr/bin/grep -q " via "
  then
    __ip=$(echo "${__route_str}" | cut -d' ' -f7)
  else
    __ip=$(echo "${__route_str}" | cut -d' ' -f5)
  fi

  __if=$(ip address show to "${__ip}" | head -1 | cut -f2 -d: | tr -d ' ' | cut -c1-2)
fi

case "${__if}" in
  en|et)
    echo -n "󰈀 "
    ;;
  wl)
    echo -n "󰖩 "
    ;;
  vp)
    echo -n " "
    ;;
  NONE)
    echo -n " no internet"
    ;;
  *)
    echo -n " ${__if} "
    ;;
esac


echo "${__ip}"
