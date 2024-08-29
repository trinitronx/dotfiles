rg-conf() {
  rg --hidden --type=conf  --pretty "$@" | perl -0777 -pe 's/\n\n/\n\0/gm' |
    fzf --read0 --ansi --multi --highlight-line --reverse --tmux 70%
}
