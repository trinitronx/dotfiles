#!/usr/bin/zsh

__update_completion() {
  local __completion_file __bin
  __bin="$1"
  __completion_file="${2:-${XDG_CACHE_HOME:-${HOME}/.cache}/oh-my-zsh/completions/${__bin}.zsh}"
  __shell="$(basename "$SHELL")"
  __gen_completion="${__bin} $3 ${__shell}"

  # If command was updated, also update the cached shell completion
  if command -v "$__bin" >/dev/null 2>&1 && ! [ -f "${__completion_file}" ] || \
    [[ "$(command -v "$__bin" 2>/dev/null)" -nt "${__completion_file}" ]]; then
    #glab completion --shell zsh > "${__completion_file}"
    eval "$__gen_completion > '${__completion_file}'" && source "${__completion_file}" || rm -f "${__completion_file}" >/dev/null 2>&1
  fi
}

# Oh My Zsh will source this location automatically
__update_completion glab "${XDG_CACHE_HOME:-${HOME}/.cache}/oh-my-zsh/completions/glab.zsh" 'completion --shell'
