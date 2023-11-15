show_host() {
  local index=$1

  local __if="NONE"
  local __ip
  local __route_str="$(ip route get 8.8.8.8 | head -1)";
  if [ -n "${__route_str}" ]
  then
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
      icon=$(get_tmux_option "@catppuccin_host_icon" "󰈀")
      ;;
    wl)
      icon=$(get_tmux_option "@catppuccin_host_icon" "󰖩")
      ;;
    vp)
      icon=$(get_tmux_option "@catppuccin_host_icon" "")
      ;;
    NONE)
      icon=$(get_tmux_option "@catppuccin_host_icon" "")
      __ip="no internet"
      ;;
    *)
      icon=$(get_tmux_option "@catppuccin_host_icon" "")
      ;;
  esac

  local color=$(get_tmux_option "@catppuccin_host_color" "$thm_magenta")
  local text=$(get_tmux_option "@catppuccin_host_text" "${__ip}")

  local module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
