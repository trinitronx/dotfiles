#!/usr/bin/zsh
# Copyright (C) © 🄯  2026 James Cuzella
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS

__git_branches_ansi() {
  # Formats recent branches and colors names via POSIX awk based on master/VULN-/SRE- prefixes
##  git branch --sort=-authordate --format='@@@%(refname:short)@@@ %(if)%(upstream)%(then)%(color:blue)-> %(upstream:lstrip=2) [%(upstream:trackshort)]%(color:reset)%(end)%09%(objectname) %(authorname)' | \
##  git branch --sort=-authordate --format='@@@%(if:equals=master)%(refname:short)%(then)%(color:green)%(else)%(color:none)%(end)%(refname:short)%(color:reset)@@@ %(if)%(upstream)%(then)%(color:blue)-> %(upstream:lstrip=2) [%(upstream:trackshort)]%(color:reset)%(end)%09%(objectname) %(authorname)' | \
  git branch --sort=-authordate --format='@@@%(if:equals=master)%(refname:short)%(then)%(color:green)%(end)%(refname:short)%(color:reset)@@@ %(if)%(upstream)%(then)%(color:blue)-> %(upstream:lstrip=2) [%(upstream:trackshort)]%(color:reset)%(end)%09%(objectname) %(authorname)' | \
  awk -v ESC="$(printf '\033')" '
    {
      start = index($0, "@@@")
      if (start > 0) {
        # Strip out the first delimiter
        rest = substr($0, start + 3)
        end = index(rest, "@@@")

        if (end > 0) {
          # Isolate the clean branch name string
          name = substr(rest, 1, end - 1)
          # Isolate the remaining line layout
          line_tail = substr(rest, end + 3)

          # Determine POSIX-compliant prefix evaluation via ~ /^[PATTERN]/
          #if (name == "master")            color = ESC "[32m"
          #if (name ~ /^VULN-/)             color = ESC "[36m"
          if (name ~ /^VULN-/)             color = ESC "[38;5;208m"
          else if (name ~ /^SRE-/)         color = ESC "[36m"
          else                             color = ESC "[97m" # Default fallback

          # Output the fully reconstructed line layout
          printf "%s%s%s%s\n", color, name, ESC "[0m", line_tail
        }
      }
    }
  '

}

git-branch-fzf() {
  # TODO: read $_git_branch_fzf_result from STDOUT of user-interactive FZF command: `fzf --ansi  --height=33% --accept-nth 1`
  ## DEBUG: echo git checkout "${_git_branch_fzf_result}"
  local _git_branch_fzf_result

  # Stream your custom formatted list directly into fzf
  _git_branch_fzf_result=$(__git_branches_ansi | fzf --ansi --height=33% --accept-nth 1 --no-multi)
  # Check if the user actually picked a branch or exited (ESC / Ctrl+C)
  if [ -n "${_git_branch_fzf_result}" ]; then
    # Extract only the first column word to drop trailing spaces or formatting residues safely
    _git_branch_fzf_result=$(echo "${_git_branch_fzf_result}" | awk '{print $1}')

    echo "Checking out branch: ${_git_branch_fzf_result}..."
    git checkout "${_git_branch_fzf_result}"
  else
    echo "No branch selected."
  fi
}

alias ggb='git-branch-fzf'
