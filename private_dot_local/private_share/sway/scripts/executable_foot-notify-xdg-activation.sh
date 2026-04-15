#!/bin/bash

app_id="$1"
category="$2"
urgency="$3"
expire_time="$4"
icon="$5"
muted="$6"
sound_name="$7"
replace_id="$8"
action_argument="$9"
title="${10}"
body="${11}"
action_name="${12}"
action_label="${13}"

notify-send --wait \
  --app-name "${app_id}" \
  --icon "${app_id}" \
  --category "${category}" \
  --urgency "${urgency}" \
  --expire-time "${expire_time}" \
  --hint "STRING:image-path:${icon}" \
  --hint "BOOLEAN:suppress-sound:${muted}" \
  --hint "STRING:sound-name:${sound_name}" \
  --replace-id "${replace_id}" "${action_argument}" \
  --print-id -- "${title} ${body}" 1>/dev/null 2>&1
# Output format - see "Window activation (focusing)" section: man 5 foot.ini
echo "${action_name}"
echo "xdgtoken=${XDG_TOKEN}"
