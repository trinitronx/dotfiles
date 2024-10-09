#!/bin/sh
# Source: https://forums.raspberrypi.com/viewtopic.php?p=2138070#p2138070
rsz() {
  if [[ -t 0 && $# -eq 0 ]]; then
    local IFS='[;' escape geometry x y
    echo -ne '\e7\e[r\e[999;999H\e[6n\e8'
    read -t 5 -sd R escape geometry
    x=${geometry##*;} y=${geometry%%;*}
    if [[ ${COLUMNS} -eq ${x} && ${LINES} -eq ${y} ]];then
      echo "${TERM} ${x}x${y}"
    else
      echo "${COLUMNS}x${LINES} -> ${x}x${y}"
      stty cols ${x} rows ${y}
    fi
  else
    print 'Usage: rsz'
  fi
}


case $( /usr/bin/tty ) in
  /dev/ttyAMA0|/dev/ttyAMA10|/dev/ttyO0|/dev/ttyS0) export LANG=C
    rsz
    ;;
esac
