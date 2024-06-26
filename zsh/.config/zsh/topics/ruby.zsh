# Enable rbenv
# TODO: Lazy-load with sandboxd.
if command -v rbenv &> /dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi
