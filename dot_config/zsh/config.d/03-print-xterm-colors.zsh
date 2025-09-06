#!/usr/bin/zsh
# Author: James Cuzella <james.cuzella@lyraphase.com>
# License: GNU AGPLv3

# Copyright (C) © 🄯  2025 James Cuzella
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

# print-xterm-256-colors: Print xterm 256 color demo with Zsh expansion
function print-xterm-256-colors() {
  for i in {0..255}; do print -Pn "%K{$i} %k%F{$i}${(l:3::0:)i}%f " "${${(M)$((i%6)):#3}:+\\n}"; done
}
