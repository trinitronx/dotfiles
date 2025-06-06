#!/usr/bin/zsh
# Add path for Zsh vendor completion functions
# Reference: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=620452;msg=7
if [ -d '/usr/share/zsh/vendor-completions' ]; then
  fpath+=( /usr/share/zsh/vendor-completions )
fi

