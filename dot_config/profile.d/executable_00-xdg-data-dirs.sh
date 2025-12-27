case ":${XDG_DATA_DIRS}:" in
  *:"${XDG_DATA_HOME:-$HOME/.local/share}":*) : ;; # no-op
  *) export XDG_DATA_DIRS="${XDG_DATA_HOME:-$HOME/.local/share}:${XDG_DATA_DIRS:-/usr/share:/usr/local/share}" ;;
esac

