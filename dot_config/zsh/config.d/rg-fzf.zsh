# Interactive filtering of a log stream
rg-fzf() {
  rg --pretty "$@" | perl -0777 -pe 's/\n\n/\n\0/gm' |
  fzf --read0 --ansi --multi --highlight-line --reverse --tmux 70%
}
