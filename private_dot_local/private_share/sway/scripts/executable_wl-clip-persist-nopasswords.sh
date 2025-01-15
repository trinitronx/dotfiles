# Copyright (C) © 🄯  2023-2024 James Cuzella
# This program is free software: See LICENSE

# Don't persist passwords (e.g. from KeePassXC)
# https://github.com/Linus789/wl-clip-persist?tab=readme-ov-file#is-it-possible-to-ignore-clipboard-events-from-password-managers
# Workaround bug: https://github.com/Linus789/wl-clip-persist/issues/7
EXCLUDE_MIME_FILTER_REGEX="(?i)^(?!image/x-inkscape-svg|x-kde-passwordManagerHint).+"
if [ -x "$(command -v wl-clip-persist)" ]; then
  pkill -x wl-clip-persist
  wl-clip-persist --clipboard regular --all-mime-type-regex \'$EXCLUDE_MIME_FILTER_REGEX\'
fi

