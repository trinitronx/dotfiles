pyenv-fzf() { pyenv activate $(pyenv virtualenvs --bare --skip-aliases | fzf ) }
