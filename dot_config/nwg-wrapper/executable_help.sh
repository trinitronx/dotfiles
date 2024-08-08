#!/bin/sh
/usr/share/sway/scripts/sbdp.py "${XDG_CONFIG_HOME:-$HOME/.config}/sway/config" | jq --raw-output 'sort_by(.category) | .[] | .action + ": <b>" + .keybinding + "</b>"'
