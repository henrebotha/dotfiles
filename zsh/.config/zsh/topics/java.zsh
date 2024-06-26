alias mvnq='mvn -q'

# TODO: Lazy-load with sandboxd.
if command -v jenv &> /dev/null; then
  eval "$(jenv init -)"
  export PATH="$HOME/.jenv/shims:$PATH"
fi
