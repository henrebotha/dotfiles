export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$XDG_DATA_HOME/zsh/history"

export LANG=en_GB.utf-8
export LANGUAGE=en_GB
export LC_CTYPE=en_GB.UTF-8
export LC_NUMERIC=en_GB.UTF-8
export LC_TIME=en_GB.UTF-8
export LC_COLLATE=en_GB.UTF-8
export LC_MONETARY=en_GB.UTF-8
export LC_MESSAGES=en_GB.UTF-8
export LC_PAPER=en_GB.UTF-8
export LC_NAME=en_GB.UTF-8
export LC_ADDRESS=en_GB.UTF-8
export LC_TELEPHONE=en_GB.UTF-8
export LC_MEASUREMENT=en_GB.UTF-8
export LC_IDENTIFICATION=en_GB.UTF-8

if [[ `uname` == 'Darwin' ]]; then
  export EDITOR='nvim'
  export MANPAGER='nvim -n -c '\''set ft=man'\'' -'
else
  export EDITOR='vim -X'
  export MANPAGER='vim -n -X -R +MANPAGER -'
  export MANWIDTH=80
fi
export MANOPT='--nh --nj'
alias vi=$EDITOR
