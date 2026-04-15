#!/usr/bin/env bash
# Wrapper around notify-send that captures the XDG activation token
# and outputs it in the format foot expects (xdgtoken=TOKEN).
#
# notify-send writes the token to --activation-token-fd, not stdout.
# This wrapper captures it via FD 3 and appends it to stdout for foot.
set -eu

token_file="$(mktemp)"
cleanup() { rm -f "$token_file"; }
trap cleanup EXIT

# Play sound
paplay /usr/share/sounds/freedesktop/stereo/message.oga

# Pass all arguments through to notify-send unchanged.
# FD 3 captures the XDG activation token; stdout (ID + action) goes to foot.
notify-send --activation-token-fd=3 "$@" 3>"$token_file"
status=$?

# Append the token line if one was received
if [ -s "$token_file" ]; then
    printf 'xdgtoken=%s\n' "$(cat "$token_file")"
fi

exit "$status"
