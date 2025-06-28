
# shellcheck shell=sh
# Function to detect the current shell
# Heuristics needed. See: https://stackoverflow.com/q/3327013/645491
detect_shell() {
    # Check for shell-specific environment variables
    if [ -n "$BASH" ]; then
        echo "bash"
    elif [ -n "$ZSH_NAME" ]; then
        echo "zsh"
    elif [ -n "$KSH_VERSION" ]; then
        echo "ksh"
    elif [ -n "$version" ]; then
        echo "tcsh"
    elif [ -n "$PS3" ] && [ -z "$PS4" ]; then
        echo "ksh"
    elif [ "$0" = "-sh" ] || [ "$0" = "sh" ]; then
        echo "sh"
    else
        # Fallback: use process name
        command ps -p "$$" -o comm=
    fi
}

# Detect the current shell
CURRENT_SHELL="$(detect_shell)"

if [ "${-//[^x]/}" = "x" ]; then
# Set PS4 for Bash or Zsh
  case "$CURRENT_SHELL" in
      *bash)
          export PS4='+ $(date "+%s.%N") (${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
          ;;
      *zsh)
          # shellcheck disable=SC2154
          export PS4='${EPOCHREALTIME} (${(%):-%N}:${LINENO}): ${funcstack[1]:+${funcstack[1]}(): }' ;
          setopt prompt_subst
          ;;
  esac
fi
