#!/usr/bin/env bash
# wrapper script for waybar with args, see https://github.com/swaywm/sway/issues/5724
# Launches waybar script via SystemD: /usr/share/sway/scripts/waybar.sh

if [ -x "$(command -v waybar)" ]; then
 (pkill waybar || exit 0)
 #systemctl --now --user enable waybar && (systemctl --user start waybar || /usr/share/sway/scripts/waybar.sh)
 systemctl --now --user enable waybar && (systemctl --user start waybar || ${XDG_DATA_HOME:-${HOME}/.local/share}/sway/scripts/waybar-debug.sh)
fi
