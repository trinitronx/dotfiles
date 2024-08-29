__view_function_code() {
  # A POSIX Regex to filter out cluttered hidden Zsh functions from the list
  __FXNS_GREP_FILTER_SYSTEM_FXNS_REGEX='(^(_|\+vi|azhw:|instant_prompt|mzc_|comp|omz|p10k|p9k|prompt_)|(_p9k_)$)'

  # Filter by default
  __FXNS_FILTER_FXNS=${__FXNS_FILTER_FXNS:-true}

  while read -r fxn_name; do

      # If filtering is on, check if fxn_name matches RegEx
      if [[ "${__FXNS_FILTER_FXNS}" == 'true' ]] && \
         grep -E -q "${__FXNS_GREP_FILTER_SYSTEM_FXNS_REGEX}" <(echo "$fxn_name")
      then
        # Do nothing / no-op
        :
      else
        # display the function definition
        declare -f "$fxn_name"
      fi
  done
}

__fxns() {
#  # A POSIX Regex to filter out cluttered hidden Zsh functions from the list
#  __FXNS_GREP_FILTER_SYSTEM_FXNS_REGEX='(^(_|\\+vi|azhw:|instant_prompt|mzc_|comp|omz|p10k|p9k|prompt_)|(_p9k_)$)'
#
#  # Filter by default
#  __FXNS_FILTER_FXNS=${__FXNS_FILTER_FXNS:-true}
#  if [[ "${__FXNS_FILTER_FXNS}" == 'true' ]]; then
#    __FXNS_USE_GREP=(grep -E -v "${__FXNS_GREP_FILTER_SYSTEM_FXNS_REGEX}")
#  else
#    # Because Zsh apparently can't handle command + pipe char inside var like Bash/POSIX sh can
#    __FXNS_USE_GREP=(cat)
#  fi

  ## Zsh-ism: ${(ok)functions} - Only works in zsh
#    grep -E -v '(^(_|\+vi|azhw:|instant_prompt|mzc_|comp|omz|p10k|p9k|prompt_)|(_p9k_)$)' | \
#    ${__FXNS_USE_GREP} | \
#set -x
  print -l ${(ok)functions} | \
    __view_function_code | \
    perl -0777 -pe 's/^}\n/}\0/gm' | \
    bat --plain --language bash --color always | \
    fzf --read0 --ansi --reverse --multi --highlight-line
#set +x
}

# Browse Zsh function definitions with fzf
fxns() {
  # Filter out function namespace clutter using grep by default
  __fxns
}

# Browse ALL Zsh function definitions with fzf
all-fxns() {
  # Don't Filter out function namespace clutter... show ALL defined functions
  export __FXNS_FILTER_FXNS=false
  __fxns
  unset __FXNS_FILTER_FXNS
}

