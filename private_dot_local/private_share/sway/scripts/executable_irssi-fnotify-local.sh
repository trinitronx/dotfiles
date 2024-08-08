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

NICK=TrinitronX
IRSSI_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}/irssi"
FILE="$IRSSI_HOME/fnotify"
NOTIFY="$(which notify-send)"
#NOTIFY=echo
BEEP="$(which paplay) /usr/share/sounds/freedesktop/stereo/message.oga"

# TODO: Fix recode upstream to work in unbuffered mode
tail -n0 -F "$FILE" | sed -u -e 's/[<@&>]//g' -e 's#[\]#\\\\#g' | \
  while read -r network from msg
  do
    # Check for NICK mention & set icon
    if echo "$msg" | grep -qi "$NICK"; then
      ICON='im-irc'
    else
      ICON='irc-channel-active'
    fi
    # escape for html/pango
    xnetwork="$(/bin/echo "${network}" | /usr/bin/recode ascii..html)"
    xfrom="$(/bin/echo "${from}" | /usr/bin/recode ascii..html)"
    xmsg="$(/bin/echo "${msg}" | /usr/bin/recode ascii..html)"
    $NOTIFY -i "$ICON" -a irssi -t 300000 -- "${xnetwork}(${xfrom})" "${xmsg}"
    $BEEP
  done
