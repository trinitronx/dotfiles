#!/bin/bash
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

time="$(date +'%a, %d. %b  %H:%M')"
echo '<span size="20000" foreground="#c6ad8f" face="monospace">'"$time"'</span>'
echo; echo '<span size="12000" foreground="#cccccc" face="monospace">'"${USER}"'@'"$(uname -n)" on "$(uname -sr)"'</span>'
echo '<span size="12000" foreground="#cccccc" face="monospace">'"$(uptime -p)"'</span>'
