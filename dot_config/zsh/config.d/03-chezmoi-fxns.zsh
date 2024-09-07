#!/usr/bin/zsh
# Author: James Cuzella <james.cuzella@lyraphase.com>
# License: GNU AGPLv3

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

# chezmoi-git-apply-check: Check diffs via chezmoi apply on feature branch
#   changed files.
function chezmoi-git-apply-check() {
  # Escape RegEx special chars in ignored filenames
  local _ignored_file_patterns="$(chezmoi ignored | \
    sed -e 's/\./\\./g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/[)]/\\)/g' \
        -e 's/[(]/\\(/g' -e 's/\?/\\?/g' -e 's/\([+*^$|]\)/\\\1/g' | \
    tr '\n' '|' )"
  git diff --name-only $(git oldest-ancestor main)..HEAD | \
    grep -Ev '^\.chezmoi|^\.' | \
    sed -e 's/dot_/\./g' \
        -e 's/\.tmpl$//g' -e 's/symlink_//g' \
        -e 's/executable_//g' -e 's/private_//g' -e 's/readonly_//g' | \
    grep -Ev "${_ignored_file_patterns%|}" | \
    sed -e 's#^#~/#' | \
    xargs chezmoi apply --verbose --dry-run --interactive
}

