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

current_screen=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused==true) | .name')
increment=0.25 ## 2023-06-23: JMC: Overriden from stock Manjaro (was: 0.5)

current_scale() {
    swaymsg -t get_outputs | jq -r '.[] | select(.focused==true) | .scale'
}

next_scale=$(current_scale)

scale() {
    swaymsg output "\"$current_screen\"" scale "$next_scale"
}

case $1'' in
'')
    current_scale
;;
'up')
    next_scale=$(echo "$(current_scale) + $increment" | bc)
    scale
    ;;
'down')
    next_scale=$(echo "$(current_scale) - $increment" | bc)
    scale
    ;;
esac

