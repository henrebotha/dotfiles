if [[ `uname` == 'Darwin' ]]; then
  export EDITOR="nvim"
else
  export EDITOR="vim -X"
fi
alias vi=$EDITOR
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/opt/local/bin:$PATH"
