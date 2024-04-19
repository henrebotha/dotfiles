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

export EDITOR='vim -X'
export MANPAGER='vim -n -X -R +MANPAGER -'
export MANWIDTH=80
export MANOPT='--nh --nj'
alias vi=$EDITOR

# Functions defined here because the way Fzf now invokes them as of 0.50.0ish
# means it doesn't have access to the contents of .zshrc. See
# https://github.com/junegunn/fzf/issues/3743#issuecomment-2065239517
altc() {
  cdup=$(git rev-parse --show-cdup 2>/dev/null)
  packages=$(altc_find_packages)
  sibling_packages=$(altc_find_sibling_packages)
  sed -r '/^\s*$/d' <<< $cdup <<< $packages <<< $sibling_packages
}

if command -v fdfind &> /dev/null; then
  alias fd='fdfind'
  altc_find_packages() {
    fdfind -t d --maxdepth=1 . 'packages/' 2>/dev/null
  }
  altc_find_sibling_packages() {
    test -z "$(git rev-parse --show-cdup)" || fdfind -t d --maxdepth=1 . "$(git rev-parse --show-cdup)packages/" 2>/dev/null
  }
else
  altc_find_packages() {
    test -d 'packages' && find 'packages' -mindepth 1 -maxdepth 1 -type d | sort 2>/dev/null
  }
  altc_find_sibling_packages() {
    test -z "$(git rev-parse --show-cdup)" || find "$(git rev-parse --show-cdup)packages" -mindepth 1 -maxdepth 1 -type d | sort 2>/dev/null
  }
fi
