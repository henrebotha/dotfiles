if [[ `uname` == 'Darwin' ]]; then
  export EDITOR="nvim"
else
  export EDITOR="vim -X"
fi
alias vi=$EDITOR
