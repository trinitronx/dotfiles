# Provide an instant variant of the nordvpn prompt segment function
prompt_nordvpn_nm() {
  [ -e /run/nordvpn/nordvpnd.sock ] || return
  if command -v nmcli 2>/dev/null 1>&2 && nmcli --fields connection.timestamp connection show --active nordtun 2>/dev/null 1>&2 ; then
    _p9k_prompt_segment "prompt_nordvpn_CONNECTED" blue white NORDVPN_ICON 0 '' "??"
  else
    _p9k_get_icon "prompt_nordvpn_DISCONNECTED" FAIL_ICON
    _p9k_prompt_segment "prompt_nordvpn_DISCONNECTED" yellow white NORDVPN_ICON 0 '' "$_p9k__ret"
  fi
}

instant_prompt_nordvpn_nm() {
  prompt_nordvpn_nm
}
