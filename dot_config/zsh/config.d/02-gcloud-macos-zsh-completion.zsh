if [ -d "$(brew --prefix)/share/google-cloud-sdk" ]; then
  _brew_prefix="$(brew --prefix)"
  [ -e "${_brew_prefix}/share/google-cloud-sdk/path.zsh.inc" ] && source "${_brew_prefix}/share/google-cloud-sdk/path.zsh.inc"
  [ -e "${_brew_prefix}/share/google-cloud-sdk/completion.zsh.inc" ] && source "${_brew_prefix}/share/google-cloud-sdk/completion.zsh.inc"
fi
