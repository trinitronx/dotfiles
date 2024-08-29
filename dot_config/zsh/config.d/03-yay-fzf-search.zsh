#!/usr/bin/zsh

# Author: James Cuzella <james.cuzella@lyraphase.com>
# License: GNU GPLv3

# Simple approach
# Avoids using complex multi-line RegExp, and instead uses awk to format the
# output.  Only uses fzf for search on all packages in a repo, or all repos
# if no args passed.
# - Use yay -Sl to get a list of packages using repo as search string
# - Use fzf to select packages
# - Use awk to format the output
yaySl-fzf() {
  yay --color=always  -Sl "$@" | \
    fzf  --ansi --multi --highlight-line --reverse --tmux 70% | \
    awk '{ print $1 "/" $2 }'
}

# Support multi-line ANSI colored package search results, multi-select & output just <repo>/<pkgname> lines
yaySs-fzf() {
  # Attempt to explain this monstrosity:
  # - sed in Extended RegExp mode, using {N; .. ; D;}
  #   > The N command appends the next line to the pattern space (thus ensuring it contains two consecutive lines in every cycle).
  #   > The D removes the first line from the pattern space (up until the first newline), readying it for the next cycle.
  #   See: https://www.gnu.org/software/sed/manual/html_node/Text-search-across-multiple-lines.html
  #
  # The naiive approach was to use some simple RegExp like one of:
  #
  #     sed -En '{N; s /^(.*\/.*)$\n^(.*)$/\1\n\2\x0/m p; D;}'
  #     sed -En '{N; s/^([^ ].*?\/.*?)$\n^(.*?)$/FIRST->\1\nSECOND->\2\x0/m p; D;}'
  #
  # However, this doesn't always work well when a package description contains a
  # literal slash '/' character.  Compare this to the approach below to see what
  # happens for an example package `libjio` which has a `/` in the description.
  #
  # Instead, we must match on the first line not starting with a space, add it
  # to the pattern space, and then match the description on the second line,
  # which should start with a space before clearing the pattern buffer with 'D'.
  # This way, we can separate the two line pairs into two different pattern spaces,
  # which we can then detect the end of and add our NULL separator.
  #
  #
  # Example: yay --color=always -Ss libjio | sed -En '/^([^ ].*?\/.*?)$/{N;!d};  s/^/\nSTART-->/ ; s/$/\n\x0<--END/; p ; /^ +.*$/{D}'
  # Output:
  #
  # START-->aur/python2-libjio 1.02-2 (+0 0.00) (Orphaned) 
  #     Userspace library for journaled, transaction-oriented I/O (Python 2 bindings)
  # <--END
  #
  # START-->aur/python-libjio 1.02-2 (+0 0.00) (Orphaned) 
  #     Userspace library for journaled, transaction-oriented I/O (Python 3 bindings)
  # <--END
  #
  # START-->aur/libjio 1.02-2 (+0 0.00) (Orphaned) 
  #     Userspace library for journaled, transaction-oriented I/O
  # <--END
  #
  # - The RegExp: match on each repo + '/' + package name + '\n' + description as
  #   multiple-line pattern, to separate each item with NULL: \0x0
  # - Then process multi-line colored input items via fzf --read0 --ansi
  # - Finally, bind 'enter' key to transform action (uses each echo-ed line to
  #   chain more actions into fzf, as if sending commands to fzf's REST API)
  # - Use become() with '#' chars insted of parentheses to avoid RegExp + escaping
  #   complexities. e.g.: "become# ... #"
  #   - This allows us to filter the output of fzf with another sed, run via
  #     `execve()` so it replaces the `fzf` process rather than outputting the
  #     selection to stdout.
  #   - The RegExp in this `sed` is a bit more complicated than the one in the
  #     original `yay` command, but it works mostly the same way. This time, we
  #     want to strip everything except the repo & package name by matching it
  #     and only output the first two capture groups which will be the <repo>
  #     and <pkgname>, separated by a literal slash `\/` character.
  #   - The character classes [a-zA-Z0-9@\._\+-]+ are used to match the repo and
  #     package name, following the allowed characters in ArchLinux package
  #     names, according to ArchWiki.
  #   - In the first RegExp, we cannot use these character classes because the
  #     ANSI escape control characters are intermixed in the `yay` output being
  #     piped into `fzf`.  So, a different approach is used with `sed`'s pattern
  #     space.
  #   multi-line strings, avoid interpreting escape sequences.
  # - Filter these through the final sed -En ... to just output <repo>/<pkgname>
  #   lines.  Phew!
  yay --color=always -Ss "$@" | \
    sed -En '/^([^ ].*?\/.*?)$/{N;!d}; s/$/\x0/; p; /^ +.*$/{D}' | \
    fzf --read0 --ansi --multi --highlight-line --reverse --tmux 70% --exact \
      --bind 'enter:transform:echo -E "become#echo -E {+} | sed -En \"{N; s/^([a-zA-Z0-9@\._\+-]+)\/([a-zA-Z0-9@\._\+-]+)\b.*\n^.*$/\1\/\2/ p; D;}\" #"'
}
