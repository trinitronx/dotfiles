
# OLD IMPLEMENTATION: Does not handle single quotes well due to /bin/sh -c ' ... ' parsing
#alias cliphist-multi-del="cliphist list | rofi -p 'Select clipboard item(s) to delete' -font 'JetBrainsMono Nerd Font 12' -dpi 36 -dmenu  -width 32  -multi-select | sed -e \"s/'/'\\\''/g\" | tr '\n' '\0' | xargs -0 -I{} -n1 /bin/sh -c 'echo '\''{}'\'' | cliphist delete'"
## 2024-05-30 JMC: Package update somehow broke DPI handling
#alias cliphist-multi-del="cliphist list | rofi -p 'Select clipboard item(s) to delete' -font 'JetBrainsMono Nerd Font 12' -dpi 36 -dmenu  -width 32  -multi-select | tr '\n' '\0' | while read -d $'\0' line ; do echo \"\$line\" | cliphist delete ; done"
## Disable DPI handling for now and default to sway's display scale
#alias cliphist-multi-del="cliphist list | rofi -p 'Select clipboard item(s) to delete' -font 'JetBrainsMono Nerd Font 12'          -dmenu  -width 32  -multi-select | tr '\n' '\0' | while read -d $'\0' line ; do echo \"\$line\" | cliphist delete ; done"
## 2024-06-24: JMC: rofi no longer supports '-width' CLI flag! - Using -theme-str 'window{ width: 60%;}'  instead!
## 2024-06-28: JMC: Making this a script so sway keyboard shortcut can run it
###alias cliphist-multi-del="cliphist list | rofi -p 'Select clipboard item(s) to delete' -font 'JetBrainsMono Nerd Font 12' -dmenu -theme-str 'window{ width: 60%;}' -multi-select | tr '\n' '\0' | while read -d $'\0' line ; do echo \"\$line\" | cliphist delete ; done"
