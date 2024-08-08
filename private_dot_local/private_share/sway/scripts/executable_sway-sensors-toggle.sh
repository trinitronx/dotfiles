#!/bin/sh
# Copyright (C) © 🄯  2023-2024 James Cuzella
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>.

sway_sensors_start_cmd="${XDG_DATA_HOME:-${HOME}/.local/share}/sway/scripts/sway-sensors-show.sh"
sway_sensors_kill_cmd="${XDG_DATA_HOME:-${HOME}/.local/share}/sway/scripts/sway-sensors-hide.sh"
sensors_overlay_state=/tmp/sway-sensors.state
_sway_output_friendlyname="${default_output:-HDMI-A-1}"

# Find dynamic HDMI / output name & export this to pass to nwg-wrapper
export SWAY_OUTPUT="$(swaymsg -t get_outputs  | jq -r ".[] | select(.type == \"output\") | [ select( ((.make + \" \" + .model + \" \" + .serial) | ascii_downcase | contains(\"${_sway_output_friendlyname}\" | ascii_downcase)) or (.name | ascii_downcase | contains(\"${_sway_output_friendlyname}\" | ascii_downcase)) ) ] | first | .name | select (.!=null)")"

if pgrep --full  'nwg-wrapper -s sway-sensors.sh' 1>/dev/null 2>&1 ; then
  sway_sensors_pid=$(pgrep --full  'nwg-wrapper -s sway-sensors.sh')
  if [ -f "$sensors_overlay_state" ]; then
    state=$(cat "$sensors_overlay_state")
    if [[ "$state" -eq "1" ]]; then
      # toggle to overlay
      pkill --full --signal 10  "nwg-wrapper -s sway-sensors.sh.*--sig_quit 31"
      echo -n "3" > $sensors_overlay_state
    else
      $sway_sensors_kill_cmd
    fi
  else
    # Assume it's in state 1 and toggle until killed
    echo -n "1" > $sensors_overlay_state
  fi
else
  $sway_sensors_start_cmd && echo -n "1" > $sensors_overlay_state
fi
