#!/bin/bash

_bool_arg=${1:-false}
SESSION_ID=$(loginctl --json=pretty list-sessions | jq -r ".[] | select(.class == \"user\" and .user == \"$(id -un)\" and .seat != null) | .session")

if [ -z "$SESSION_ID" ]; then
  echo 'Error detecting user session ID from loginctl' >&2
  exit 1
fi

if [ -n "$_bool_arg" ] && [ "$_bool_arg" == 'true' ]; then
  _bool_arg='boolean:true'
else
  _bool_arg='boolean:false'
fi

dbus-send --system --print-reply --dest=org.freedesktop.login1 "/org/freedesktop/login1/session/${SESSION_ID}" org.freedesktop.login1.Session.SetLockedHint "${_bool_arg}";
