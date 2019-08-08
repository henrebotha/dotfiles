if [[ `uname` == 'Darwin' ]]; then
  export EDITOR="nvim"
else
  export EDITOR="vim -X"
fi
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/opt/local/bin:$PATH"
