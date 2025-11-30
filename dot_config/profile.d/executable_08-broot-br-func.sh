# shellcheck shell=sh
# Depends on detect_shell() from ./00a-set-debug-prompt.sh
CURRENT_SHELL="$(detect_shell)"

case "$CURRENT_SHELL" in
  *bash)
        source ${XDG_CONFIG_HOME:-$HOME/.config}/broot/launcher/bash/br
        ;;
  *zsh)
        source ${XDG_CONFIG_HOME:-$HOME/.config}/broot/launcher/bash/br
        ;;
esac
