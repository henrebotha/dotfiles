# Use brew git, not OSX git.
if [[ `uname` == 'Darwin' ]]
then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi
export PATH="/usr/local/bin:$PATH"
export SHELL="zsh"
export ZSH=/Users/henrebotha/.oh-my-zsh
