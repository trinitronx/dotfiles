#!/bin/sh

export NVM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm

# Depends on detect_shell + env var in 00a-set-debug-prompt.sh
case "$CURRENT_SHELL" in
    *bash)
        [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
        ;;
    *zsh)
        : # no-op (no zsh completion shipped)
        ;;
esac

