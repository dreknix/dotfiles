#!/usr/bin/env bash

show_primary_ip() {
  local index=$1

  local icon="#(tmux show-option -gqv '@primary_ip_icon')"
  local color=$(get_tmux_option "@primary_ip_color" "$thm_magenta")
  local text=$(get_tmux_option "@primaray_ip_text" "#{primary-ip}")

  local module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
