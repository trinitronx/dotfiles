
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
        #command ps -p "$$" -o comm=
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
          # Use color + p10k powerline glyphs if interactive
          if [ "${-//[^i]/}" = "i" ]; then
              # shellcheck disable=SC2154
              export PS4=$'\n''%b%f%K{239}%D{%s.%N} %k%K{018}%F{239}%{ %G%}%f%k%K{018} %{󰈮 %G%}('$'\e]8;;void://file/''%x:%I:0'$'\a''%x:%I'$'\e]8;;\a'') %k%K{221}%F{018}%{ %G%}%f%k%F{black}%K{221} %(0l,%0<${psvar[1]::=}${psvar[1]::=${${(%)__percentN__:-%N}:#${(%)_filePercent_x_:-%x}}}<,)%2(L.%{%G%}%{󰶻 %G%}[%B%L%b].%{%G%}) %k%f%F{221}%{ %G%}%f '$'\n''%{ '$'\b''%}%B%K{030}  %{ %G%}%1(V.%1v:%i%{()%G%}.%35<…<%N:%i) %k%b%F{030}%{ %G%}%f %(0l,%0<${psvar::=${psvar:#${_eval_::=(eval)}}}<,)%B%F{249}' ;
          else
              # shellcheck disable=SC2154
              export PS4='%D{%s.%N} (%x:%I): %(0l,%0<${psvar[1]::=}${psvar[1]::=${${(%)__percentN__:-%N}:#${(%)_filePercent_x_:-%x}}}<,) %2(L.%{%G%}%{󰶻 %G%}[%L].) '$'\n''%{ '$'\b''%}  %1(V.%1v:%i().%35<…<%N(%):%i)  %(0l,%0<${psvar::=${psvar:#${_eval_::=(eval)}}}<,)' ;
          fi
          setopt prompt_subst
          ;;
  esac
fi
