#!/usr/bin/env sh
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

# https://blog.dhampir.no/content/sleeping-without-a-subprocess-in-bash-and-how-to-sleep-forever
snore() {
    local IFS
    [[ -n "${_snore_fd:-}" ]] || exec {_snore_fd}<> <(:)
    read -r ${1:+-t "$1"} -u $_snore_fd || :
}

DELAY=0.2

while snore $DELAY; do
  if pgrep nwg-drawer; then
    alt_icon='open'
  else
    alt_icon='closed'
  fi

tooltip='nw-drawer launcher'
text='foo test'
class='nwg-drawer-button'
percentage=100
#  echo "{\"text\":\"\",\"alt\":\"$alt_icon\",\"tooltip\":\"nw-drawer launcher\",\"class\":\"nwg-drawer-button\",\"percentage\":100}" | \

  echo "{\"text\":\"\",\"alt\":\"$alt_icon\",\"tooltip\":\"$tooltip\",\"class\":\"$class\",\"percentage\":$percentage}" | \
    jq --monochrome-output --unbuffered --compact-output
  pkill -SIGRTMIN+13 waybar
done
exit 0
