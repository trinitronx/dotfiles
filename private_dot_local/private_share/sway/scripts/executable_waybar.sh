#!/usr/bin/env sh
# wrapper script for waybar with args, see https://github.com/swaywm/sway/issues/5724

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd )"

USER_CONFIG_PATH=$HOME/.config/waybar/config.jsonc
USER_STYLE_PATH=$HOME/.config/waybar/style.css

if [ -f "$USER_CONFIG_PATH" ]; then
    USER_CONFIG=$USER_CONFIG_PATH
fi

if [ -f "$USER_STYLE_PATH" ]; then
    USER_STYLE=$USER_STYLE_PATH
fi

#export GTK_DEBUG=interactive
echo "$0 : Starting waybar"
set -x
waybar --log-level trace -c "${USER_CONFIG:-"/usr/share/sway/templates/waybar/config.jsonc"}" -s "${USER_STYLE:-"/usr/share/sway/templates/waybar/style.css"}" $@ 1>/tmp/waybar.log 2>&1 &
set +x
echo "$0 : Waybar started... PID = $!"
