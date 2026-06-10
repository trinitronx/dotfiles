#!/usr/bin/zsh
# Copyright (C) © 🄯  2026 James Cuzella
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS

typeset -g short_help_text
short_help_text='enter to checkout branch, alt-y to copy hash, alt-v to open in pager'

read -r -d '' long_help_text <<EOSHORT
Actions:
enter  = checkout branch
alt-y  = copy hash
alt-v  = open in pager
?      = show long help
ctrl-alt-l = clear / refresh screen & hide long help

Navigation:
ctrl-/ = Toggle Preview: 70%, 99%, hidden, default
ctrl-j, down = select next commit
ctrl-k, up   = select prev commit
ctrl-h = goto latest commit
ctrl-l = goto first commit
ctrl-b, pageup   = page up commits
ctrl-f, pagedown = page down commits
alt-up,   alt-b = scroll preview page up
alt-down, alt-f = scroll preview page down
alt-j = scroll preview half page down
alt-k = scroll preview half page up
alt-h, home = goto preview top
alt-l, end  = goto preview end
EOSHORT

__git_branches_ansi() {
  # Formats recent branches and colors names via POSIX awk based on master/VULN-/SRE- prefixes
##  git branch --sort=-authordate --format='@@@%(refname:short)@@@ %(if)%(upstream)%(then)%(color:blue)-> %(upstream:lstrip=2) [%(upstream:trackshort)]%(color:reset)%(end)%09%(objectname) %(authorname)' | \
##  git branch --sort=-authordate --format='@@@%(if:equals=master)%(refname:short)%(then)%(color:green)%(else)%(color:none)%(end)%(refname:short)%(color:reset)@@@ %(if)%(upstream)%(then)%(color:blue)-> %(upstream:lstrip=2) [%(upstream:trackshort)]%(color:reset)%(end)%09%(objectname) %(authorname)' | \
  git branch --color=always --sort=-authordate --format='@@@%(if:equals=master)%(refname:short)%(then)%(color:green)%(end)%(if:equals=main)%(refname:short)%(then)%(color:green)%(end)%(refname:short)%(color:reset)@@@ %(if)%(upstream)%(then)%(color:blue)-> %(upstream:lstrip=2) [%(upstream:trackshort)]%(color:reset)%(end)%09%(objectname) %(authorname)' | \
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

typeset -g _gitBranchToHash _viewGitLogBranch _viewGitLogBranchUnfancy _clipboardCopyCmd _unameOS
#_gitBranchToHash="git show-ref --hash=7 --branches '{}' | grep -o '[a-f0-9]\{7,40\}' | head -1 | tr -d '\n'"
_gitBranchToHash="git rev-parse --short=7 '{1}' | tr -d '\n'"
_viewGitLogBranch='git log --graph --decorate --oneline --abbrev-commit --color=always {1}'
_viewGitLogBranchUnfancy='git log --graph --decorate --oneline --all --abbrev-commit --color=always {1}'

_unameOS="$(uname -s)"
case "${_unameOS}" in
    Linux*)     if command -v wayland-scanner >/dev/null 2>&1 || [[ "$XDG_SESSION_TYPE" == *wayland* ]]; then
                  _clipboardCopyCmd="wl-copy"
                elif [[ "$XDG_SESSION_TYPE" != *wayland* ]]; then
                  _clipboardCopyCmd="xclip -selection clipboard -in"
                fi;;
    Darwin*)    _clipboardCopyCmd="pbcopy";;
    CYGWIN*)    ;& # fall-through
    MINGW*)     ;& # fall-through
    MSYS_NT*)   _clipboardCopyCmd="perl -pe 'chomp if eof' | clip.exe";;
    *)          # unknown OS... assume other Unix + Xorg
                _clipboardCopyCmd="xclip -selection clipboard -in"
                ;;
esac

#        --bind "alt-v:execute:$_viewGitLogBranchUnfancy | echo \${PAGER:-less} --pattern='(^|[^[:alnum:]_./-]){1}([^a-zA-Z0-9_./-]|\$)' | less" \
#        --bind "alt-v:execute:$_viewGitLogBranchUnfancy | \${PAGER:-less} --use-backslash --pattern='(^|[^[:alnum:]_./-]){1}([^a-zA-Z0-9_./()-]|\\$)'" \
git-branch-fzf() {
  __git_branches_ansi | \
    fzf --ansi --height=50% --accept-nth 1 --no-multi \
        --preview="$_viewGitLogBranch" \
        --header "enter to checkout, alt-y to copy hash, alt-v to open in pager" \
        --bind "alt-v:execute:$_viewGitLogBranchUnfancy | \${PAGER:-less} --use-backslash --use-color -DH- -D2+c -D1+k -D3+w +\"\$(printf '/\0232(^|[^[:alnum:]_./-])({1})([^a-zA-Z0-9_./-]|\\\\\$)')\"" \
        --bind "alt-y:execute:$_gitBranchToHash | ${_clipboardCopyCmd}" \
        --prompt ' > ' \
        --bind 'ctrl-/:+change-preview-window(70%|99%|hidden|)' \
        --bind 'ctrl-/:+refresh-preview' \
        --bind 'alt-up:preview-page-up' \
        --bind 'alt-down:preview-page-down' \
        --bind 'alt-b:preview-page-up' \
        --bind 'alt-f:preview-page-down' \
        --bind 'alt-j:preview-half-page-down' \
        --bind 'alt-k:preview-half-page-up' \
        --bind 'ctrl-b:page-up' \
        --bind 'ctrl-f:page-down' \
        --bind 'home:preview-top' \
        --bind 'end:preview-bottom' \
        --bind 'ctrl-h:first' \
        --bind 'ctrl-l:last' \
        --bind 'alt-h:preview-top' \
        --bind 'alt-l:preview-bottom' \
        --bind "ctrl-alt-l:clear-screen+change-header($short_help_text)" \
        --bind "?:change-header($long_help_text)" \
        --bind 'load:+change-prompt: > ' \
        --color 'fg:#999999,fg+:#ccd7d4,bg:#1b2224,gutter:#1b2224,preview-bg:#141a1b,border:#707a7a,scrollbar:#2eb398,pointer:#ac3562,hl:#ac74f9,query:#ccd7d4,prompt:#45ff82,marker:#ac3562,preview-label:#2eb398,preview-border:#2eb398,hl+:#b07aff,header:#45ff82,separator:#697521'

}

git-branch-checkout() {
  # TODO: read $_git_branch_fzf_result from STDOUT of user-interactive FZF command: `fzf --ansi  --height=33% --accept-nth 1`
  ## DEBUG: echo git checkout "${_git_branch_fzf_result}"
  local _git_branch_fzf_result

  # Stream your custom formatted list directly into fzf
  _git_branch_fzf_result=$(__git_branches_ansi | git-branch-fzf)
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
