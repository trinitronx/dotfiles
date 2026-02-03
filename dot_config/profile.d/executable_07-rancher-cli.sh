if [ -e "$HOME/.rd/bin" ]; then
  case ":${PATH}:" in
    *:"$HOME/.rd/bin":*) : ;; # no-op
    *) export PATH="$HOME/.rd/bin:$PATH" ;;
  esac
fi

