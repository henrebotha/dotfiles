export LANG=en_GB.utf-8
export ZSH='/home/hbotha/.oh-my-zsh'
if [[ `uname` == 'Darwin' ]]; then
  export EDITOR='nvim'
  export MANPAGER='nvim -n -c '\''set ft=man'\'' -'
else
  export EDITOR='vim -X'
  export MANPAGER='vim -n -X -R +MANPAGER -'
  export MANWIDTH=80
fi
alias vi=$EDITOR
