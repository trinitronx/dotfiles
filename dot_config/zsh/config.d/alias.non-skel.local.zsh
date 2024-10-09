alias termbin="nc termbin.com 9999"
alias vi='vim'
# Override default oh-my-zsh dir aliases
# Orig Defined: /usr/share/oh-my-zsh/lib/directories.zsh
# List directory contents
alias eza-ls='eza --icons --color-scale --classify --git'
alias lsa='eza-ls -la --header'
alias l='eza-ls -la --header'
alias ll='eza-ls -l --header'
alias la='eza-ls -la --header'
alias lt='eza-ls -l --header --tree --git-ignore --binary'
alias lat='eza-ls -la --header --tree --binary'
alias lat-gi="eza-ls -la --header --tree --ignore-glob='.git'  --git-ignore --binary"
alias latgi='lat-gi'

# list dir stack
alias dv='dirs -v'
# Terraform -> OpenTofu
alias terraform='tofu'

# https://github.com/irssi/irssi/issues/640
alias irssi="irssi --home=${XDG_CONFIG_HOME:-${HOME}/.config}/irssi"

## Fuzzy Find Aliases

alias imv-last-ss="makoctl history | jq -r '.data | .[] | map(select(.summary.data == \"Screenshot saved\")) | first | .body.data'  | imv"
alias pushd-src='_pushd_src() { ARGS="$@"; pushd ~/src/pub/$(find ~/src/pub -mindepth 1 -maxdepth 1 -type d -printf "%T@/%f\0" | sort -z -n -r | cut -z -d/ -f2 | fzf $ARGS --read0 ) }; _pushd_src'

# Source: https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/
alias activate-venv='source "$HOME/.virtualenvs/$(find $HOME/.virtualenvs/  -mindepth 1 -maxdepth 1  -type d -printf "%f\0" | fzf --read0)/bin/activate"'

# pipe output to fzf in tail mode + multi-select
# Tip: Pipe this to wl-copy to search & select some log lines
alias fzf-pipe-tail='fzf --tail 100000 --tac --no-sort --exact --multi'

# fzf preview files
# Manjaro Sway Matcha-dark-sea GTK theme
# --style=header-filesize,header-filename,full

alias ff="fzf -m --preview \
      'bat --tabs 2 --terminal-width=\"\$FZF_PREVIEW_COLUMNS\" --wrap=auto --paging=never --theme=Matcha-Dark --style='${BAT_STYLE:-header-filesize,header-filename,full}' --force-colorization {}' \
    --info default --border \
    --preview-window right,50,border-rounded \
    --prompt ' > ' \
    --bind 'ctrl-/:+change-preview-window(70%|99%|hidden|)' \
    --bind 'ctrl-/:+refresh-preview' \
    --bind 'alt-up:preview-page-up' \
    --bind 'alt-down:preview-page-down' \
    --bind 'home:preview-top' \
    --bind 'end:preview-bottom' \
    --bind '?:change-header:$(echo -e ctrl-/ = Toggle Preview: 70%, 99%, hidden, 50%\\nshift-up = Scroll preview up\\nshift-down = Scroll preview down\\nalt-up = Scroll preview page up\\nalt-down = Scroll preview page down\\nhome = Scroll preview to top\\nend = Scroll preview to end)' \
    --bind 'load:+change-prompt: > ' \
    --bind 'focus:+transform-preview-label:echo ▶ {} ◀;' \
    --bind 'focus:+transform-header:exa --icons --color-scale --oneline {}; echo -n \"  \"; file --brief {};' \
    --color 'fg:#999999,fg+:#ccd7d4,bg:#1b2224,gutter:#1b2224,preview-bg:#141a1b,border:#707a7a,scrollbar:#2eb398,pointer:#ac3562,hl:#ac74f9,query:#ccd7d4,prompt:#45ff82,marker:#ac3562,preview-label:#2eb398,preview-border:#2eb398,hl+:#b07aff,header:#45ff82,separator:#697521'"

#    --prompt '⧖> ' \
#    --prompt '󰔟 > ' \
#    --prompt ' > ' \
#    --prompt ' > ' \
#preview-border:#2eb398 #Matcha Bright Teal
#preview-border:#3b758c #Matcha Dim Teal
# preview-label:#45ff82 #Matcha Bright Mint Green

# Cisco vt100 screenrc RS-232 serial console
alias cisco-console='screen -c ~/.config/screen/screenrc.cisco-vt100 $@'
