#!/bin/sh
makoctl history | jq -r '.data | .[] | map(select(.summary.data == "Screenshot saved")) | first | .body.data'  | xargs dragon-drop -s 400 --stdin
