ZSH_THEME="henrebotha"

COMPLETION_WAITING_DOTS="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(git osx zsh-nvm vi-mode virtualbox mvn docker)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

. $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.

# Enable rbenv.
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Fix yarn binary issue https://github.com/yarnpkg/yarn/issues/648
# Do `yarn global bin` to get the path
export PATH="/usr/local/Cellar/node/8.2.1/bin:$PATH"

# # zsh-autoenv
# . ~/.dotfiles/lib/zsh-autoenv/autoenv.zsh

# Shortcut for finding aliases.
alias cmd='alias | grep '
# Shortcut for discarding changes to all unstaged, tracked files.
alias gdisc='git checkout -- $(git ls-files -m)'
# Shortcuts for hiding changes from git (e.g. so that we can override configs
# in dev without risk of committing them by accident).
alias ghide='git update-index --skip-worktree'
alias gunhide='git update-index --no-skip-worktree'
alias ghidden='git ls-files -v . | grep ^S'

alias emacs="/usr/local/Cellar/emacs-plus/25.1/Emacs.app/Contents/MacOS/Emacs -nw"
alias vim='nvim'
alias v='nvim'

alias t='tree -L'

alias tx='tmuxinator s'
alias txe='tmuxinator new'
alias ta='tmux a -t'
alias tai='tmux new-session -t' # mnemonic: "tmux attach independent"
alias tk='tmux kill-session -t'
alias tl='tmux ls'
alias tn='tmux new-session -s'

alias elmc='elm-repl'
alias elmr='elm-reactor'
alias elmm='elm-make'
alias elmp='elm-package'

alias mvnq='mvn -q'

alias s='. ~/.zshrc'

alias swine='/Applications/Wine\ Staging.app/Contents/Resources/wine/bin/wine'
alias swine64='/Applications/Wine\ Staging.app/Contents/Resources/wine/bin/wine64'
alias swineboot='/Applications/Wine\ Staging.app/Contents/Resources/wine/bin/wineboot'
# alias swinebuild='winebuild'
alias swinecfg='/Applications/Wine\ Staging.app/Contents/Resources/wine/bin/winecfg'
alias swineconsole='/Applications/Wine\ Staging.app/Contents/Resources/wine/bin/wineconsole'
# alias swinecpp='winecpp'
alias swinedbg='/Applications/Wine\ Staging.app/Contents/Resources/wine/bin/winedbg'
# alias swinedump='winedump'
alias swinefile='/Applications/Wine\ Staging.app/Contents/Resources/wine/bin/winefile'
# alias swineg++='wineg++'
# alias swinegcc='winegcc'
# alias swinemaker='winemaker'
alias swinemine='/Applications/Wine\ Staging.app/Contents/Resources/wine/bin/winemine'
alias swinepath='/Applications/Wine\ Staging.app/Contents/Resources/wine/bin/winepath'
alias swineserver='/Applications/Wine\ Staging.app/Contents/Resources/wine/bin/wineserver'
# alias swinetricks='winetricks'

rgl() {
  rg --color=always $@ | less -R
}

# https://dougblack.io/words/zsh-vi-mode.html
# Enable Vi mode.
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# Default 400ms delay after ESC is too slow. Increase this value if this breaks
# other commands that depend on the delay.
export KEYTIMEOUT=1 # 100 ms

# # Functionality for displaying normal mode indicator in Vi mode.
# function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$bg[blue]$fg[yellow]%}[% NORMAL]% %{$reset_color%}"
#     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$EPS1"
#     zle reset-prompt
# }
# zle -N zle-line-init
# zle -N zle-keymap-select
# # End Vi mode functionality

# List folder contents after cd.
cdl() { cd $1; la }

# A lovely script that watches files for changes and automatically commits them
# to git. Nice to use for note-taking.
autocommit() {
  # commit any changes since last run
  date +%Y-%m-%dT%H:%M:%S%z; git add $@; git commit -m "AUTOCOMMIT"; echo
  # now commit changes whenever files are saved
  fswatch -0 $@ | xargs -0 -n 1 sh -c "date +%Y-%m-%dT%H:%M:%S%z; git add .; git commit -m \"AUTOCOMMIT\"; echo"
}

# https://github.com/thoughtbot/dotfiles/blob/master/bin/replace
# Find and replace by a given list of files.
#
# replace foo bar **/*.rb

replace() {
  find_this="$1"
  shift
  replace_with="$1"
  shift

  items=("${(@f)$(ag -l --nocolor "$find_this" "$@")}")
  temp="${TMPDIR:-/tmp}/replace_temp_file.$$"
  IFS=$'\n'
  for item in $items; do
    sed "s/$find_this/$replace_with/g" "$item" > "$temp" && mv "$temp" "$item"
  done
}

# Fix the macOS pasteboard when it breaks
# alias fixpboard='ps aux | grep '\''[p]board'\'' | perl -p -e '\''s/ +/ /g'\'' | cut -d '\'' '\'' -f 2 | xargs kill -9'
alias fixpboard='pkill -9 pboard'

# Whenever a command is not found, prompt the user to install it via homebrew.
# command_not_found_handler is a built-in Zsh hook, called automatically.
command_not_found_handler() {
  echo "Command $1 not found. Install it with b for brew, g for gem, n for npm."
  read -sk answer
  if [[ $answer = "b" || $answer = "B" ]]; then
    echo "brew install $1"
    brew install "$1"
  elif [[ $answer = "g" || $answer = "G" ]]; then
    echo "gem install $1"
    gem install "$1"
  elif [[ $answer = "n" || $answer = "N" ]]; then
    echo "npm install $1"
    npm install -g "$1"
  fi
}

# fzf keybinds/completion
[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh

# # zsh-async
# # Installation
# if [[ ! -a ~/.zsh-async ]]; then
#   git clone -b 'v1.5.2' https://github.com/mafredri/zsh-async ~/.zsh-async
# fi
# . ~/.zsh-async/async.zsh

# vagrant_status() {
#   VAGRANT_CWD=$1 vagrant status
# }

# # Configuration
# async_init

# async_start_worker vagrant_prompt_worker -n

# vagrant_prompt_callback() {
#   local output=$@
#   if [[ $output =~ 'running' ]]; then
#     H_PROMPT_VAGRANT_UP='v↑'
#   else
#     H_PROMPT_VAGRANT_UP=''
#   fi
#   async_job vagrant_prompt_worker vagrant_status $(pwd)
# }

# async_register_callback vagrant_prompt_worker vagrant_prompt_callback

# async_job vagrant_prompt_worker vagrant_status $(pwd)
# # end zsh-async

# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

. ~/.dev

bindkey '^f' reset-prompt

# OPAM configuration
. /Users/henrebotha/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# Regular Colors

export COL_BLACK="\e[0;30m"
export COL_RED="\e[0;31m"
export COL_GREEN="\e[0;32m"
export COL_YELLOW="\e[0;33m"
export COL_BLUE="\e[0;34m"
export COL_PURPLE="\e[0;35m"
export COL_CYAN="\e[0;36m"
export COL_WHITE="\e[0;37m"

# Bold

export COL_BOLD_BLACK="\e[1;30m"
export COL_BOLD_RED="\e[1;31m"
export COL_BOLD_GREEN="\e[1;32m"
export COL_BOLD_YELLOW="\e[1;33m"
export COL_BOLD_BLUE="\e[1;34m"
export COL_BOLD_PURPLE="\e[1;35m"
export COL_BOLD_CYAN="\e[1;36m"
export COL_BOLD_WHITE="\e[1;37m"

# Underline

export COL_UND_BLACK="\e[4;30m"
export COL_UND_RED="\e[4;31m"
export COL_UND_GREEN="\e[4;32m"
export COL_UND_YELLOW="\e[4;33m"
export COL_UND_BLUE="\e[4;34m"
export COL_UND_PURPLE="\e[4;35m"
export COL_UND_CYAN="\e[4;36m"
export COL_UND_WHITE="\e[4;37m"

# Background

export COL_BG_BLACK="\e[40m"
export COL_BG_RED="\e[41m"
export COL_BG_GREEN="\e[42m"
export COL_BG_YELLOW="\e[43m"
export COL_BG_BLUE="\e[44m"
export COL_BG_PURPLE="\e[45m"
export COL_BG_CYAN="\e[46m"
export COL_BG_WHITE="\e[47m"

# High Intensty

export COL_HI_BLACK="\e[0;90m"
export COL_HI_RED="\e[0;91m"
export COL_HI_GREEN="\e[0;92m"
export COL_HI_YELLOW="\e[0;93m"
export COL_HI_BLUE="\e[0;94m"
export COL_HI_PURPLE="\e[0;95m"
export COL_HI_CYAN="\e[0;96m"
export COL_HI_WHITE="\e[0;97m"

# Bold High Intensty

export COL_HI_BOLD_BLACK="\e[1;90m"
export COL_HI_BOLD_RED="\e[1;91m"
export COL_HI_BOLD_GREEN="\e[1;92m"
export COL_HI_BOLD_YELLOW="\e[1;93m"
export COL_HI_BOLD_BLUE="\e[1;94m"
export COL_HI_BOLD_PURPLE="\e[1;95m"
export COL_HI_BOLD_CYAN="\e[1;96m"
export COL_HI_BOLD_WHITE="\e[1;97m"

# High Intensty backgrounds

export COL_HI_BG_BLACK="\e[0;100m"
export COL_HI_BG_RED="\e[0;101m"
export COL_HI_BG_GREEN="\e[0;102m"
export COL_HI_BG_YELLOW="\e[0;103m"
export COL_HI_BG_BLUE="\e[0;104m"
export COL_HI_BG_PURPLE="\e[0;105m"
export COL_HI_BG_CYAN="\e[0;106m"
export COL_HI_BG_WHITE="\e[0;107m"

# Reset

export COL_RESET="\e[0m"

# ---

if [[ `uname` == 'Darwin' ]]
then
  alias ip-eth="ipconfig getifaddr en0"
  alias ip-wifi="ipconfig getifaddr en1"
fi
