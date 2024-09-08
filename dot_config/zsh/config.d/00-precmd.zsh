typeset -g POWERLEVEL9K_TERM_SHELL_INTEGRATION=true
#function mzc_termsupport_prompt_jump() {
#    print -Pn "\e]133;A\e\\"
#}
#add-zsh-hook precmd mzc_termsupport_prompt_jump

#precmd() {
#    echo 'Adding precmd prompt OSC 133'
#    print -Pn "\e]133;A\e\\"
#}

# Disables the omz_termsupport_precmd() function in oh-my-zsh
#DISABLE_AUTO_TITLE=true

# Re-define our own using 50 char truncation instead of 15 char
#ZSH_THEME_TERM_TAB_TITLE_IDLE="%50<..<%~%<<" #50 char left truncated PWD
#ZSH_THEME_TERM_TITLE_IDLE="%n@%m:%~"

# Runs before showing the prompt
#function mzc_termsupport_precmd {
#  [[ "${DISABLE_MY_AUTO_TITLE:-}" == true ]] && return
#  title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
#}

# Settings for zsh-tmux-auto-title
# ZSH_TMUX_AUTO_TITLE_TARGET='window'
#ZSH_TMUX_AUTO_TITLE_TARGET='pane'
# ZSH_TMUX_AUTO_TITLE_SHORT=false
# ZSH_TMUX_AUTO_TITLE_SHORT_EXCLUDE=
# ZSH_TMUX_AUTO_TITLE_EXPAND_ALIASES:=true
# ZSH_TMUX_AUTO_TITLE_IDLE_TEXT=%shell
#50 char left truncated PWD
#ZSH_TMUX_AUTO_TITLE_IDLE_TEXT='%50<..<%~'
# ZSH_TMUX_AUTO_TITLE_IDLE_DELAY=1
# ZSH_TMUX_AUTO_TITLE_PREFIX=
