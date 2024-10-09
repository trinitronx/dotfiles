if [ -e "/opt/gnu-screen-debug/bin" ]; then
  case ":${PATH}:" in
    *:"/opt/gnu-screen-debug/bin":*) : ;; # no-op
    *) export PATH="/opt/gnu-screen-debug/bin:$PATH" ;;
  esac
fi

