#!/usr/bin/zsh
# Original Source: https://gist.github.com/junegunn/f4fca918e937e6bf5bad?permalink_comment_id=3356674#gistcomment-3356674
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


alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(brightblack)%C(bold)%cr% C(auto)%an %G?" "$@"'

_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | tr -d '\n'"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always --show-signature % | delta'"
_viewGitLogLineUnfancy="$_gitLogLineToHash | xargs -I % sh -c 'git show %'"

_unameOS="$(uname -s)"
case "${_unameOS}" in
    Linux*)     if command -v wayland-scanner && [[ "$XDG_SESSION_TYPE" == *wayland* ]]; then
                  _clipboardCopyCmd="wl-copy"
                elif [[ "$XDG_SESSION_TYPE" == ** ]]; then
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

# ANSI Colors
c_reset='\033[0m'
c_black='\033[0;30m'
c_red='\033[0;31m'
c_green='\033[0;32m'
c_yellow='\033[0;33m'
c_blue='\033[0;34m'
c_magenta='\033[0;35m'
c_cyan='\033[0;36m'
c_white='\033[0;37m'

short_help_text='enter to view, alt-y to copy hash, alt-v to open in vim'

read -r -d '' long_help_text <<EOSHORT
Actions:
enter  = show commit
alt-y  = copy hash
alt-v  = open in vim
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


# Transform %G? GPG output into colored JetbrainsMono Nerd Font Icons
# View current mappings via:
#   echo -e 'G= G\nU= U\nB= B\nY= Y\nX= X\nR= R\nN= N\nE= E' | _sigVerifyIconFilter
# For letter meanings:  git help log  | grep -A3 -E '%G\?'
alias _sigVerifyIconFilter="sed -e \"s/G$/$(echo -e $c_green)✔  $(echo -e $c_reset)/; s/U$/$(echo -e $c_cyan)✔   ❔$(echo -e $c_reset)/; s/B$/$(echo -e $c_red)✘ 󰝧  $(echo -e $c_reset)/; s/Y$/$(echo -e $c_green)✔$(echo -e ${c_reset}${c_yellow})   $(echo -e $c_reset)/; s/X$/$(echo -e $c_green)✔$(echo -e ${c_reset}${c_yellow})  $(echo -e $c_reset)/; s/R$/$(echo -e $c_green)✔$(echo -e ${c_reset}${c_magenta})   $(echo -e $c_reset)/; s/N$/$(echo -e $c_cyan)$(echo -e $c_reset)/;  s/E$/$(echo -e $c_blue)   ❔$(echo -e $c_reset)/;\""
#_sigVerifyIconFilter="sed -e \"s/N$//;\""

gls() {

    glNoGraph | _sigVerifyIconFilter | \
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
            --header "enter to view, alt-y to copy hash, alt-v to open in vim" \
            --bind "enter:execute:$_viewGitLogLine   | less -R" \
            --bind "alt-v:execute:$_viewGitLogLineUnfancy | vim -" \
            --bind "alt-y:execute:$_gitLogLineToHash | ${_clipboardCopyCmd}" \
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
