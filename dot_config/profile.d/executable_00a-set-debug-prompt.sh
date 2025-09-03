
# shellcheck shell=sh
# Function to detect ps variant
detect_ps() {
  # Detect ps supported args
  if ps --help 2>&1 | grep -q "Try 'ps --help <simple|list|output"; then
    # GNU variant procps(-ng)
    if ps --help list 2>&1 | grep -q '\-p'; then
      ps_p_arg='-p $$'
      ps_ucomm_alias=ucomm
      ps_o_arg="-o ${ps_ucomm_alias}="
      ps_shell_detect_args="${ps_p_arg} ${ps_o_arg}"
      shell_detect_cmd="\\command \\ps ${ps_shell_detect_args}"
    elif ps --help output 2>&1 | grep -q '\-o'; then
      # No -p arg available, fallback to grep & comm
      ps_p_arg=''
      ps_ucomm_alias=comm
      ps_o_arg="-o pid=,${ps_ucomm_alias}="
      ps_shell_detect_args="${ps_p_arg} ${ps_o_arg}"
      shell_detect_cmd="\\command \\ps ${ps_shell_detect_args} | grep -E \"^ *\$\$ +\" | awk \"{ print \\\$2 }\" " ;
    else
      # No ps available or detection failed.  Fallback to /proc/
      shell_detect_cmd='\command \gawk '\''BEGIN{RS=""}; NR==1{print; exit}'\'' /proc/$$/cmdline | sed -e '\''s/\x00/ /g'\'' | cut -f1 -d" "  ' ;
    fi
  else
    # Some other variant ps
    # Assume ucomm is not available & fallback to more portable comm
    if ps --help 2>&1 | grep -q '\-p' ; then
      ps_p_arg='-p $$'
      ps_ucomm_alias=comm
      ps_o_arg="-o ${ps_ucomm_alias}="
      ps_shell_detect_args="${ps_p_arg} ${ps_o_arg}"
      shell_detect_cmd="\\command \\ps ${ps_shell_detect_args}"
    elif ps -h 2>&1 | grep -q '\-o'; then
      # No -p arg available, fallback to grep
      ps_p_arg=''
      ps_ucomm_alias=comm
      ps_o_arg="-o pid=,${ps_ucomm_alias}="
      ps_shell_detect_args="${ps_p_arg} ${ps_o_arg}"
      shell_detect_cmd="\\command \\ps ${ps_shell_detect_args} | grep -E \"^ *\$\$ +\" |  awk \"{ print \$2 }\" " ;
    else
      # No ps available or detection failed.  Fallback to /proc/
      shell_detect_cmd='\command \gawk '\''BEGIN{RS=""}; NR==1{print; exit}'\'' /proc/$$/cmdline | sed -e '\''s/\x00/ /g'\'' | cut -f1 -d" "  ' ;
    fi
  fi
}
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
        detect_ps
        eval $shell_detect_cmd
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
          export PS4='%D{%s.%N} (${(%):-%N}:%i): ${funcstack[1]:+${funcstack[1]}(): }' ;
          setopt prompt_subst
          ;;
  esac
fi
