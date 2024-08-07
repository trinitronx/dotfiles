#!/usr/bin/env sh
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

# toggles the help wrapper state

VISIBILITY_SIGNAL=30
QUIT_SIGNAL=31
LOCKFILE="$HOME/.local/help_disabled"

if [ "$1" = "--toggle" ]; then
    if [ -f "$LOCKFILE" ]; then
        rm "$LOCKFILE"
    else
        touch "$LOCKFILE"
    fi
    # toggles the visibility
    pkill -f -${VISIBILITY_SIGNAL} 'nwg-wrapper.*-s help.sh'

else
    # makes sure no "old" wrappers are mounted (on start and reload)
    pkill -f -${QUIT_SIGNAL} 'nwg-wrapper.*-s help.sh'
    # mounts the wrapper to all outputs
    for output in $(swaymsg -t get_outputs --raw | jq -r '.[].name'); do
        # sets the initial visibility
        if [ -f "$LOCKFILE" ]; then
            VISIBILITY="--invisible"
        else
            VISIBILITY="--no-invisible"
        fi
        nwg-wrapper ${VISIBILITY} -o "$output" -sv ${VISIBILITY_SIGNAL} -sq ${QUIT_SIGNAL} -s help.sh -p left -a end &
    done
fi
