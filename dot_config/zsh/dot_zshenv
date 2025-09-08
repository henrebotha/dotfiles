export TERM='xterm-16color'

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
  sed -E '/^\s*$/d' \
    <(altc_cdup &) \
    <(altc_find_linked_worktrees &) \
    <(altc_find_packages &) \
    <(altc_find_sibling_packages &)
}

altc_cdup() {
  git rev-parse --show-cdup 2>/dev/null
}

altc_find_linked_worktrees() {
  if command -v grealpath &> /dev/null; then
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
      return
    fi
    current="$(git rev-parse --show-toplevel)"
    for line in $(git worktree list | cut -d' ' -f1); do
      if ! [[ "$line" == "$current" ]]; then
        grealpath --relative-to=$(pwd) $line
        return
      fi
    done
  fi
}

if command -v fdfind &> /dev/null; then
  alias fd='fdfind'
fi

if command -v fd &> /dev/null; then
  altc_find_packages() {
    fd -t f --min-depth=2 -F 'package.json' 2>/dev/null | xargs dirname | sort
  }
  altc_find_sibling_packages() {
    test -z "$(git rev-parse --show-cdup)" || fd -t f --min-depth=2 -F 'package.json' "$(git rev-parse --show-cdup)" 2>/dev/null | xargs dirname | sort
  }
else
  altc_find_packages() {
    test -d 'packages' && find 'packages' -mindepth 1 -maxdepth 1 -type d | sort 2>/dev/null
  }
  altc_find_sibling_packages() {
    test -z "$(git rev-parse --show-cdup)" || find "$(git rev-parse --show-cdup)packages" -mindepth 1 -maxdepth 1 -type d | sort 2>/dev/null
  }
fi
