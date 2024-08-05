#!/bin/sh
sway_time_start_cmd=${XDG_DATA_HOME:-${HOME}/.local/share}/sway/scripts/sway-time-show.sh
sway_time_kill_cmd=${XDG_DATA_HOME:-${HOME}/.local/share}/sway/scripts/sway-time-hide.sh
time_overlay_state=/tmp/sway-time.state
_sway_output_friendlyname="${default_output:-HDMI-A-1}"
export _sway_output_friendlyname

#_sway_output_friendlyname_DEBUG=swaymsg -t get_outputs  | jq ".[] | select(.type == \"output\") | select( ((.make + \" \" + .model + \" \" + .serial) | contains(\"${_sway_output_friendlyname}\")) or (.name | contains(\"${_sway_output_friendlyname}\")) ) | { name: .name, make: .make, model: .model, serial: .serial }"

# Find dynamic HDMI / output name & export this to pass to nwg-wrapper
export SWAY_OUTPUT="$(swaymsg -t get_outputs  | jq -r ".[] | select(.type == \"output\") | [ select( ((.make + \" \" + .model + \" \" + .serial) | ascii_downcase | contains(\"${_sway_output_friendlyname}\" | ascii_downcase)) or (.name | ascii_downcase | contains(\"${_sway_output_friendlyname}\" | ascii_downcase)) ) ] | first | .name | select (.!=null)")"

if pgrep --full  'nwg-wrapper -s sway-time.sh' 1>/dev/null 2>&1 ; then
  sway_time_pid=$(pgrep --full  'nwg-wrapper -s sway-time.sh.*--sig_quit 31')
  if [ -f "$time_overlay_state" ]; then
    state=$(cat "$time_overlay_state")
    if [[ "$state" -eq "1" ]]; then
      # toggle to overlay
      pkill --full --signal 10  "nwg-wrapper -s sway-time.sh.*--sig_quit 31"
      echo -n "3" > $time_overlay_state
    else
      $sway_time_kill_cmd
    fi
  else
    # Assume it's in state 1 and toggle until killed
    echo -n "1" > $time_overlay_state
  fi
else
  $sway_time_start_cmd && echo -n "1" > $time_overlay_state
fi
