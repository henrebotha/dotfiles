# ------------------------------------------------------------------------------
# Zsh
# ------------------------------------------------------------------------------

os=`uname`

# Disabled on macOS due to line-chomping behaviour.
# https://github.com/robbyrussell/oh-my-zsh/issues/5765
if [[ "$os" != 'Darwin' ]]; then
  # http://stackoverflow.com/a/844299
  expand-or-complete-with-dots() {
    echo -n "\e[31m…\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey -M emacs "^I" expand-or-complete-with-dots
  bindkey -M viins "^I" expand-or-complete-with-dots
  bindkey -M vicmd "^I" expand-or-complete-with-dots
fi

# This fixes slow Git tab completion. It needs to precede the Git plugin,
# apparently.
# https://stackoverflow.com/a/9810485/1966418
# https://superuser.com/a/459057/317254
# http://www.zsh.org/mla/workers/2011/msg00491.html
__git_files () {
    _wanted files expl 'local files' _files
}

if [[ ! -d ~/.zplug ]]; then
  export ZPLUG_HOME=~/.zplug
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi
source ~/.zplug/init.zsh

zplug 'plugins/vi-mode', from:oh-my-zsh
zplug 'plugins/gitfast', from:oh-my-zsh
zplug 'plugins/ripgrep', from:oh-my-zsh
zplug 'zsh-users/zsh-autosuggestions'
zplug 'larkery/zsh-histdb'
zplug 'benvan/sandboxd'
zplug load

. ~/henrebotha.zsh-theme
setopt promptsubst

# https://github.com/nickmccurdy/sane-defaults/blob/master/home/.zshrc
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt no_list_ambiguous

# export MANPATH="/usr/local/man:$MANPATH"

# TODO: Try to make this work. The idea is that we set ZSH_COMPDUMP before we
# (OMZ) call compinit, so that the dump doesn't end up in our home dir.
# if [ ! -d ~/.cache/zsh ]; then
#   mkdir -p ~/.cache/zsh
# fi
# export $ZSH_COMPDUMP="~/.cache/zsh/zcompdump-$ZSH_VERSION"

if [ -d ~/zsh_help ]; then
  export HELPDIR=~/zsh_help
  unalias run-help
  autoload run-help
fi

alias help=run-help

alias s='. ~/.zshrc'
alias :q=exit # Welp

# Allow **foo as shorthand for **/*foo.
setopt glob_star_short

# Don't expand history inline.
setopt hist_verify

# Store history & share it across sessions.
setopt share_history
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.zsh_history

# Create the alias ~dev for ~/dev. This will be reflected in both the prompt,
# and in completion for commands such as cd or ls.
hash -d -- dev=/home/hbotha/dev

# On dir change, run a function that, if we're in
# ~/git_tree/agency-api-client/$branch_name, will add the subdirs of ./packages
# to $cdpath.
# TODO: Generalise this to read from a map of directory patterns to "package" dirs.
chpwd_functions=($chpwd_functions chpwd_add_packages)
chpwd_add_packages() {
  if [[ $(pwd) =~ '^/home/hbotha/git_tree/attractions-content/([A-Za-z0-9\-_]+)/?\b' ]]; then
    package_dir='/home/hbotha/git_tree/attractions-content/'$match[1]'/packages'
    if [[ ! ${cdpath[(ie)$package_dir]} -le ${#cdpath} ]]; then
      cdpath=($cdpath $package_dir)
    fi
  else
    # Remove things that look like package_dir from cdpath
    cdpath=(${cdpath:#/home/hbotha/git_tree/attractions-content/*/packages})
  fi
}

# chpwd is not invoked on shell startup, so we define a self-destructing
# function to do this once. Source:
# https://gist.github.com/laggardkernel/b2cbc937aa1149530a4886c8bcc7cf7c
_self_destruct_hook() {
  local f
  for f in ${chpwd_functions}; do
    "$f"
  done

  # Remove self from precmd
  precmd_functions=(${(@)precmd_functions:#_self_destruct_hook})
  builtin unfunction _self_destruct_hook
}
(( $+functions[add-zsh-hook] )) || autoload -Uz add-zsh-hook
add-zsh-hook precmd _self_destruct_hook

# ------------------------------------------------------------------------------
# Zsh-histdb
# ------------------------------------------------------------------------------
alias hf=histdb\ --forget\ --exact

# ------------------------------------------------------------------------------
# Zsh-autosuggestions
# ------------------------------------------------------------------------------

export ZSH_AUTOSUGGEST_USE_ASYNC=1

if type histdb > /dev/null; then
  ZSH_AUTOSUGGEST_STRATEGY=histdb # (histdb history completion)

  _zsh_autosuggest_strategy_histdb() {
    typeset -g suggestion
    suggestion=$(_histdb_query "
        SELECT commands.argv
        FROM history
          LEFT JOIN commands ON history.command_id = commands.rowid
          LEFT JOIN places ON history.place_id = places.rowid
        WHERE
          commands.argv LIKE '$(sql_escape $1)%' AND
          places.dir = '$(sql_escape $PWD)'
        GROUP BY commands.argv
        ORDER BY history.start_time desc
        LIMIT 1
    ")
  }
fi

# ------------------------------------------------------------------------------
# Docker
# ------------------------------------------------------------------------------

alias d=docker
alias dc=docker-compose

# ------------------------------------------------------------------------------
# Kubernetes
# ------------------------------------------------------------------------------

source ~/.kubectl.zsh
source ~/.bkcloud.zsh
alias k=kubectl

# ------------------------------------------------------------------------------
# Java
# ------------------------------------------------------------------------------

# TODO: Lazy-load with sandboxd.
if which jenv > /dev/null; then
  eval "$(jenv init -)"
  export PATH="$HOME/.jenv/shims:$PATH"
fi

# ------------------------------------------------------------------------------
# Ruby
# ------------------------------------------------------------------------------

# Enable rbenv
# TODO: Lazy-load with sandboxd.
if type rbenv > /dev/null; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# ------------------------------------------------------------------------------
# Yarn
# ------------------------------------------------------------------------------

# Fix yarn binary issue https://github.com/yarnpkg/yarn/issues/648
# Do `yarn global bin` to get the path
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# ------------------------------------------------------------------------------
# Git
# ------------------------------------------------------------------------------

alias g='noglob git'

# A lovely script that watches files for changes and automatically commits them
# to git. Nice to use for note-taking.
autocommit() {
  # commit any changes since last run
  date +%Y-%m-%dT%H:%M:%S%z; git add $@; git commit -m "AUTOCOMMIT"; echo
  # now commit changes whenever files are saved
  fswatch -0 $@ | xargs -0 -n 1 sh -c "date +%Y-%m-%dT%H:%M:%S%z; git add .; git commit -m \"AUTOCOMMIT\"; echo"
}

# ------------------------------------------------------------------------------
# Tmux
# ------------------------------------------------------------------------------

# Let's install tpm, if we have Tmux but not tpm
if [ -d "$HOME/.tmux" -a ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone git@github.com:/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

alias tx='tmuxinator s'
alias txe='tmuxinator new'
alias ta='tmux a -t'
alias tai='tmux new-session -t' # mnemonic: "tmux attach independent"
alias tk='tmux kill-session -t'
alias tl='tmux ls'
typeset -A tmux_sessions
export tmux_sessions=(
  [dev]=~/git_tree
  [dotfiles]=~/dev
  [games]=~/Games
  [gp]=~/git_tree
  [notes]=~/git_tree/notes
)
tn() {
  : ${1:?tn needs a session name.}
  args=(${@:2})
  session_root=${tmux_sessions[$1]:-$HOME}
  tmux new-session -s $1 -c $session_root $args
}
tna() {
  auto_sessions=(
    dev
    dotfiles
    gp
    notes
  )
  for session in ${(@k)tmux_sessions:*auto_sessions}; do
    tn $session -d
  done
}

# Fix broken mouse reporting after ssh exits abruptly
alias fix-mouse-reporting='printf '\''\e[?1000l'\'''

# ------------------------------------------------------------------------------
# Vim
# ------------------------------------------------------------------------------

# If we're in a Git repo, name the server after that repo. Otherwise, give it a
# misc name.
vim_servername() {
  if g rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "$(git repo-and-branch-name)"
  else
    echo 'VIM'
  fi
}
# Launch with -X to prevent communication with X11 on startup, improving startup
# speed in Tmux
alias v='vim -X --servername $(vim_servername)'
# Use as pager
alias vpage='ifne vim -X -R - -n'
# Source ~/.vimrc in every running Vim server instance
alias vu='for server in `vim --serverlist`; do; v --servername $server --remote-send '\'':source ~/.vimrc<cr>'\''; done'

# ------------------------------------------------------------------------------
# Tree
# ------------------------------------------------------------------------------

alias t='tree -L'

# ------------------------------------------------------------------------------
# Elm
# ------------------------------------------------------------------------------

alias elmc='elm-repl'
alias elmr='elm-reactor'
alias elmm='elm-make'
alias elmp='elm-package'

# ------------------------------------------------------------------------------
# Maven
# ------------------------------------------------------------------------------

alias mvnq='mvn -q'

# ------------------------------------------------------------------------------
# Ripgrep
# ------------------------------------------------------------------------------

rgl() {
  rg --color=always $@ | less -R
}

# ------------------------------------------------------------------------------
# shellcheck
# ------------------------------------------------------------------------------

if ! type "shellcheck" > /dev/null; then
  if [[ "$os" == 'Darwin' ]]; then
    brew install shellcheck
  fi
fi

# ------------------------------------------------------------------------------
# macOS
# ------------------------------------------------------------------------------

if [[ "$os" == 'Darwin' ]]; then
  # Fix the macOS pasteboard when it breaks
  # alias fixpboard='ps aux | grep '\''[p]board'\'' | perl -p -e '\''s/ +/ /g'\'' | cut -d '\'' '\'' -f 2 | xargs kill -9'
  alias fixpboard='pkill -9 pboard'

  alias ip-eth="ipconfig getifaddr en0"
  alias ip-wifi="ipconfig getifaddr en1"
fi

# ------------------------------------------------------------------------------
# Key bindings & related config
# ------------------------------------------------------------------------------

# https://dougblack.io/words/zsh-vi-mode.html
# Enable Vi mode.
bindkey -v

autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey -M viins '^N' copy-earlier-word
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward
bindkey '^[[Z' reverse-menu-complete # SHIFT-TAB to go back
bindkey -M vicmd '^\' push-line-or-edit # "context switch" half-written command
bindkey -M viins '^\' push-line-or-edit
bindkey -M vicmd 'gcc' vi-pound-insert

# Enable quoted & bracketed text objects!!! Thanks @mr_v
autoload -U select-quoted select-bracketed
zle -N select-quoted
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

# Default 400ms delay after ESC is too slow. Increase this value if this breaks
# other commands that depend on the delay.
export KEYTIMEOUT=1 # 100 ms

# ------------------------------------------------------------------------------
# Completion
# ------------------------------------------------------------------------------

# Allow tab completion to match hidden files always
setopt globdots

# ------------------------------------------------------------------------------
# Misc
# ------------------------------------------------------------------------------


alias l='ls -Ahlp --color=auto --group-directories-first --hyperlink --time-style=long-iso'
alias ld='ls -Ahl --color=auto --directory --hyperlink --time-style=long-iso'

alias fd='fdfind'

# fzf keybinds/completion
[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--bind "f1:execute(less -f {})"'
# --files: List files, do not search them
# --follow: Follow symlinks
# --hidden: Search hidden paths
# --glob: Additional conditions (exclude .git)
# --no-ignore: Do not respect .gitignore and the like
export FZF_DEFAULT_COMMAND='rg --files --glob "!.git/*" --hidden --no-ignore'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND=altc

altc() {
  cdup=$(git rev-parse --show-cdup 2>/dev/null)
  packages=$(fdfind -t d --maxdepth=1 . 'packages/' 2>/dev/null)
  sibling_packages=$($(test -z "$(git rev-parse --show-cdup)") || fdfind -t d --maxdepth=1 . "$(git rev-parse --show-cdup)packages/" 2>/dev/null)
  cat <(echo $cdup) <(echo $packages) <(echo $sibling_packages) | sed -r '/^\s*$/d'
}

alias fzfp='fzf --preview '\''[[ $(file --mime {}) =~ binary ]] &&
                 echo {} is a binary file ||
                 (highlight -O ansi -l {} ||
                  coderay {} ||
                  rougify {} ||
                  cat {}) 2> /dev/null | head -200'\'

fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# if [ ! -e ~/isomorphic-copy ]; then
#   g clone git@github.com:ms-jpq/isomorphic-copy.git ~/isomorphic-copy
# fi
# export PATH="$HOME/isomorphic-copy/bin:$PATH"

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

# ------------------------------------------------------------------------------
# Direnv
# ------------------------------------------------------------------------------

eval "$(direnv hook zsh)"

# https://gist.github.com/ctechols/ca1035271ad134841284
# On slow systems, checking the cached .zcompdump file to see if it must be
# regenerated adds a noticable delay to zsh startup.  This little hack restricts
# it to once a day.  It should be pasted into your own completion file.
#
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C
autoload -U +X bashcompinit && bashcompinit

export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

# zprof
# zmodload -u zsh/zprof
