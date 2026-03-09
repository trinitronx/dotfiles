#!/usr/bin/zsh
# Copyright (C) © 🄯  2026 James Cuzella
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS


__view_alias_code() {
  # A POSIX Regex to filter out cluttered hidden Zsh functions from the list
  __ALS_GREP_FILTER_SYSTEM_ALIASES_REGEX='^(_|-|\\-|CHECK_.*|CTRLSTR|EMORINSTR|EMPTYSTR|FUNCSTR|IDSTR|INVALIDSTR|PRINTSTR|RESULT_.*|WRONGSTR|ZEROSTR|ZSIO)$'

  # Filter by default
  __ALS_FILTER_ALIASES=${__ALS_FILTER_ALIASES:-true}

  while read -r alias_name; do

      # If filtering is on, check if alias_name matches RegEx
      # special case: '-' must be handled so 'echo -' does not eat it
      if [[ "${__ALS_FILTER_ALIASES}" == 'true' ]] && \
         \grep -E -q "${__ALS_GREP_FILTER_SYSTEM_ALIASES_REGEX}" <(echo "${alias_name/-/\-}")
      then
        # Do nothing / no-op
        :
      else
        # display the alias definition
        alias "$alias_name"
      fi
  done
}

__aliases() {

  # POSIX version (from Google Gemini)
  # 1. Get all aliases
  # 2. Colorize with bat (using bash syntax)
  # 3. Pipe to fzf with a preview window to see the full command if it's long
#  alias | \
#    bat --plain --language bash --color always | \
#    fzf --ansi \
#        --reverse \
#        --multi \
#        --header "Search Aliases (Enter to copy to clipboard)" \
#        --preview 'echo {}' \
#        --preview-window='up:1:wrap'
# | \
#    awk -F'[ =]' '{print $2}' | pbcopy # Optional: copies the alias name to clipboard

  ## Zsh-ism: ${(ok)aliases} - Only works in zsh
  print -l ${(ok)aliases} | \
    __view_alias_code | \
    bat --plain --language bash --color always | \
    perl -0777 -pe 's/\n/\0/g' | \
    fzf --read0 --ansi --reverse --multi --highlight-line
}

# Browse shell alias definitions with fzf
als() {
  # Filter out alias namespace clutter using grep by default
  __aliases
}

# Browse ALL shell alias definitions with fzf
all-aliases() {
  # Don't Filter out alias namespace clutter... show ALL defined aliases
  export __ALS_FILTER_ALIASES=false
  __aliases
  unset __ALS_FILTER_ALIASES
}

