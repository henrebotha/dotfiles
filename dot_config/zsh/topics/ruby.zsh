# Enable rbenv
# TODO: Lazy-load with sandboxd.
if command -v rbenv &> /dev/null; then
  append_path "$HOME/.rbenv/bin"
  eval "$(rbenv init -)"
fi
