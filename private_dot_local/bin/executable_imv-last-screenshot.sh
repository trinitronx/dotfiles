#!/bin/sh
# Copyright (C) © 🄯  2023-2025 James Cuzella
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

# makoctl history disappeared! See: https://github.com/emersion/mako/releases/tag/v1.10.0
busctl --json=short --user call  org.freedesktop.Notifications /fr/emersion/Mako fr.emersion.Mako ListHistory \
  | jq -r '.data | .[] |
    map(
      select(.summary.data == "Screenshot saved")
    ) | first | .body.data' | \
  imv
