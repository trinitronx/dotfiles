#!/bin/zsh
# shellcheck shell=bash

# This script provides a way to interactively filter a log stream using fzf.
# Each user-facing function is a wrapper around the _fzf_tail_mode function,
# which is the one that actually calls fzf with the desired options.

# Interactive filtering of a log stream
_fzf_tail_mode() {
  file_name="${1:-foo.log}"
  fzf "${@:2}" --tail 100000 --tac --no-sort --exact --scheme=history --multi \
      --preview-window down:5:hidden:wrap \
      --preview "echo -n {} |  bat --file-name '${file_name}' --paging=never --force-colorization --terminal-width \$FZF_PREVIEW_COLUMNS" \
      --bind 'ctrl-/:+change-preview-window(30%|70%|99%|hidden|)' \
      --bind 'ctrl-/:+refresh-preview' \
      --bind 'alt-/:toggle-preview' \
      --bind 'alt-up:preview-page-up' \
      --bind 'alt-down:preview-page-down' \
      --bind 'home:preview-top' \
      --bind 'end:preview-bottom' \
      --bind "?:change-header:$(echo -e ctrl-/ = Toggle Preview: 30%, 70%, 99%, hidden, 50%\\nalt-/ = Toggle Preview: on, hidden\\nshift-up = Scroll preview up\\nshift-down = Scroll preview down\\nalt-up = Scroll preview page up\\nalt-down = Scroll preview page down\\nhome = Scroll preview to top\\nend = Scroll preview to end)" \
      --bind "focus:+transform-header:[[ -n {} ]] && rg --max-count=1 --vimgrep --stop-on-nonmatch --fixed-strings --color=always --max-columns=\$FZF_COLUMNS --max-columns-preview {} '$file_name';" \
      --color 'fg:#999999,fg+:#ccd7d4,bg:#1b2224,gutter:#1b2224,preview-bg:#141a1b,border:#707a7a,scrollbar:#2eb398,pointer:#ac3562,hl:#ac74f9,query:#ccd7d4,prompt:#45ff82,marker:#ac3562,preview-label:#2eb398,preview-border:#2eb398,hl+:#b07aff,header:#45ff82,separator:#697521'
}

# Actual user-facing functions

# tail-fzf: interactively filter a log stream
# @param $1: the log file to tail
# @param $2: additional fzf options
tail-fzf() {
  tail -F "$1" | _fzf_tail_mode "$1" "${@:2}"
}

# tail-grep-fzf: interactively filter a log stream, grepping for a pattern to ignore
# @param $1: any extra grep flags + the pattern to ignore
# @param $2: the log file to tail
tail-grepv-fzf() {
  last_idx=$(($# - 1))
  # Zsh-specific syntax (but sometimes buggy)
  # tail -F "$@[-1]" | grep --line-buffered -v "$@[1,${last_idx}]" | _fzf_tail_mode
  # Bash/Zsh/Ksh string indexing syntax
  tail -F "${@: -1}" | grep --line-buffered -v "${@:1:$last_idx}" | _fzf_tail_mode "${@: -1}"
}
