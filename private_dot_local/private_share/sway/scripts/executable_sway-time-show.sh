#!/bin/sh
# Copyright (C) © 🄯  2024 James Cuzella
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

#swaylock_lock_cmd=swaylock
##--daemonize didn't work
sway_time_kill_cmd=${XDG_DATA_HOME:-${HOME}/.local/share}/sway/scripts/sway-time-hide.sh
SWAY_OUTPUT="${SWAY_OUTPUT:-HDMI-A-1}"

nwg-wrapper -s sway-time.sh -o "$SWAY_OUTPUT" -r 1000 -c timezones.css -p right -mr 50 -a start -mt 0 -j right --layer 1 --sig_layer 10 --sig_quit 31 &
sway_time_pid=$!

#$swaylock_lock_cmd &
#swaylock_pid=$!

## NOTE: This no longer works as of sway >= 1.8
## Reference: https://www.reddit.com/r/swaywm/comments/11ig9z9/mucking_about_with_layers/

# Wait & signal nwg-wrapper time to jump to layer 3 (overlay)
#sleep 2 && kill -10 $sway_time_pid
#wait $swaylock_pid && time $sway_time_kill_cmd

#$swaylock_lock_cmd && $sway_time_kill_cmd
