case ":${PATH}:" in
  *:"/usr/local/sbin":*) : ;; # no-op
  *) export PATH="/usr/local/sbin:$PATH" ;;
esac

