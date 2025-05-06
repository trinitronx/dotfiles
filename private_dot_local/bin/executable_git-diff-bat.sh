#!/bin/bash

# TODO: Work on multiple files display & diff line higlighting

mapfile -t highlight_lines < <(
  git diff --patch --unified=0 | grep -E '^@@' | \
    sed -E -e 's/^@@.*[-+]([[:digit:]]+(,[[:digit:]]+)?)( [-+]([[:digit:]]+(,[[:digit:]]+)?))?.*@@.*/\1 \4/g' | \
    tr ' ' '\n' | grep -v '^$' | sort | uniq | sed -e  's/,/:+/g'
)

declare -a highlight_args
for arg in "${highlight_lines[@]}"; do
  highlight_args+=("--highlight-line=$arg")
done

mapfile -t staged_files_list < <(
  git diff --cached --diff-filter=AM --textconv --name-only
)
mapfile -t files_list < <(
  git diff --diff-filter=AM --textconv --name-only
)

if (( ${#staged_files_list[@]} > 0 )); then
 echo 'WARN: Some files are staged in git! bat --diff cannot show these (yet)' >&2
fi

if (( ${#files_list[@]} > 0 )); then
  bat --diff --diff-context=4 "${highlight_args[@]}" "$@" "${files_list[@]}"
else
  echo "ERROR: No files in git diff" >&2
  exit 1
fi
