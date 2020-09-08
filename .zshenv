if [[ `uname` == 'Darwin' ]]; then
  export EDITOR='nvim'
  export MANPAGER='nvim -n -c '\''set ft=man'\'' -'
else
  export EDITOR='vim -X'
  export MANPAGER='vim -n -X -R +MANPAGER -'
fi
alias vi=$EDITOR
