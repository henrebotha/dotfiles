# Enable pyenv
# TODO: Lazy-load with sandboxd?
if command -v pyenv &> /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  # eval "$(pyenv init -)"
fi
