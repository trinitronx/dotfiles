#!/bin/sh
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
