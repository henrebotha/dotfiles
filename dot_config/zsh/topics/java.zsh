alias mvnq='mvn -q'

# TODO: Lazy-load with sandboxd.
if command -v jenv &> /dev/null; then
  eval "$(jenv init -)"
  append_path "$HOME/.jenv/shims"
fi
