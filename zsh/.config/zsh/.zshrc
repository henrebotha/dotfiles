# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

os=`uname`

. "$ZDOTDIR"/.zsh_util_install

# Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh
export ZSH_CACHE_DIR="$ZDOTDIR"

zcomet load ohmyzsh 'plugins/mise'
zcomet load ohmyzsh 'plugins/vi-mode'
zcomet load 'romkatv/powerlevel10k'
zcomet load 'Aloxaf/fzf-tab'
zcomet load 'olets/zsh-abbr'
zcomet load 'olets/zsh-test-runner'
zcomet load 'romkatv/zsh-bench'
# Zcomet recommends loading this last
zcomet load 'zsh-users/zsh-autosuggestions'

zcomet compinit

export PATH="$HOME/.local/bin:$PATH"
export PATH="$ZDOTDIR/tools:$PATH"

. "$ZDOTDIR"/config/history.zsh

fpath=( "$ZDOTDIR"/completions "${fpath[@]}" )

# Case-insensitive (all), partial word and then substring completion
# https://github.com/nickmccurdy/sane-defaults/blob/1f6d632/home/.zshrc#L12
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt no_list_ambiguous

# Key bindings for fzf-tab
zstyle ':fzf-tab:*' fzf-bindings 'right:accept'
# Use 16 colours, because fzf-tab ignores FZF_DEFAULT_OPTS
zstyle ':fzf-tab:*' fzf-flags --color=16

if [ -d ~/zsh_help ]; then
  export HELPDIR=~/zsh_help
  unalias run-help
  autoload run-help
fi

alias help=run-help

alias s=". $ZDOTDIR/.zshrc"
alias :q=exit # Welp

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'

setopt extended_glob
# Allow **foo as shorthand for **/*foo.
setopt glob_star_short
# Resolve symlinks & dots (..) to their true absolute path.
setopt chase_links

setopt auto_pushd
export DIRSTACKSIZE=10

alias dv='dirs -v'

# Create aliases such as ~dev for ~/dev. This will be reflected in both the
# prompt, and in completion for commands such as cd or ls.
hash -d -- dev="$HOME"/dev
hash -d -- dotfiles="$HOME"/dev/dotfiles

# On dir change, run a function that, if we're in
# ~/git_tree/agency-api-client/$branch_name, will add the subdirs of ./packages
# to $cdpath.
# TODO: Generalise this to read from a map of directory patterns to "package" dirs.
chpwd_functions=($chpwd_functions chpwd_add_packages)
chpwd_add_packages() {
  if [[ $(pwd) =~ "$HOME"'/git_tree/attractions/content/([A-Za-z0-9\-_]+)/?\b' ]]; then
    package_dir="$HOME"'/git_tree/attractions/content/'$match[1]'/packages'
    if [[ ! ${cdpath[(ie)$package_dir]} -le ${#cdpath} ]]; then
      cdpath=($cdpath $package_dir)
    fi
  else
    # Remove things that look like package_dir from cdpath
    cdpath=(${cdpath:#"$HOME"'/git_tree/attractions/content/'$match[1]'/packages'})
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

# Zsh global aliases
alias -g @q="2> /dev/null"
alias -g @qq=">/dev/null 2>&1"
alias -g @errout="2>&1"

# Topic config
ZSH_TOPICFILE="$ZDOTDIR/zsh-topics"
typeset -A topics

init_topics() {
  if [[ ! -s "$ZSH_TOPICFILE" ]]; then
    # Define default config here
    > "$ZSH_TOPICFILE" <<CONFIG
# elm
# java
# js
# ruby
CONFIG
  fi

  # Read topics
  for topic in "${(f)"$(<$ZSH_TOPICFILE)"}"; do
    if [[ ! $topic =~ '^#' ]]; then
      topics+=("$topic" 1)
    fi
  done

  unset topic
}

init_topics

purge_topics() {
  rm "$ZSH_TOPICFILE"
}

for topic enabled in "${(@kv)topics}"; do
  if [[ $enabled == 1 ]]; then
    source "$ZDOTDIR"/topics/"$topic".zsh
  fi
done
unset topic
unset enabled

# Docker
alias d=docker
alias dc=docker-compose

# Kubernetes
[ -f "$HOME/.kubectl.zsh" ] && . "$HOME/.kubectl.zsh"
alias k=kubectl

# Git
alias g='git'

# mise
alias m=mise

# A lovely script that watches files for changes and automatically commits them
# to git. Nice to use for note-taking.
autocommit() {
  # commit any changes since last run
  date +%Y-%m-%dT%H:%M:%S%z; git add $@; git commit -m "AUTOCOMMIT"; echo
  # now commit changes whenever files are saved
  fswatch -0 $@ | xargs -0 -n 1 sh -c "date +%Y-%m-%dT%H:%M:%S%z; git add .; git commit -m \"AUTOCOMMIT\"; echo"
}

# Tmux
# Let's install tpm, if we have Tmux but not tpm
if [ -d "$HOME/.tmux" -a ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone git@github.com:/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

alias tx='tmuxinator s'
alias txe='tmuxinator new'
alias ta='tmux a -t'
alias tai='tmux new-session -t' # mnemonic: "tmux attach independent"
alias tk='tmux kill-session -t'
alias tl='tmux ls 2> /dev/null || echo '\''Tmux is not running.'\'
typeset -A tmux_sessions
export tmux_sessions=(
  [dev]=~/git_tree
  [diy]=~/Documents/DIY
  [dotfiles]=~/dev/dotfiles
  [games]=~/Games
  [notes]=~/git_tree/notes
  [personal-dev]=~/dev
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
    notes
    personal-dev
  )
  for session in ${(@k)tmux_sessions:*auto_sessions}; do
    tn $session -d
  done
}

# Wait for a string to appear in another pane before executing a command
tmux_await() {
  # Args: window & pane (ints), then grep pattern to match, then command to run
  : ${1:?tmux_await needs a window number (prefix-i).}
  : ${2:?tmux_await needs a pane number (prefix-i or prefix-q).}
  : ${3:?tmux_await needs a pattern to look for.}
  : ${4:?tmux_await needs a command to execute.}
  while ! tmux capture-pane -p -t @"$1".%"$2" | grep "$3"; do
    sleep 1
  done; ${@:4}
}

# Fix broken mouse reporting after ssh exits abruptly
alias fix-mouse-reporting='printf '\''\e[?1000l'\'''

# Vim
# If we're in a Git repo, name the server after that repo. Otherwise, give it a
# misc name, based either on Tmux session or otherwise just "VIM".
vim_servername() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "$(git repo-and-branch-name)"
  elif [ -n "$TMUX" ]; then
    echo "$(tmux display-message -p '#{session_name}')"
  else
    echo 'VIM'
  fi
}
# Launch with -X to prevent communication with X11 on startup, improving startup
# speed in Tmux
if vim --version | grep '\+clientserver' > /dev/null; then
  alias vim='vim -X --servername $(vim_servername)'
else
  alias vim='vim -X'
fi
# Use as pager
alias vpage='ifne vim -X -R - -n'
# Source ~/.vimrc in every running Vim server instance
alias vu='for server in `vim --serverlist`; do; vim --servername $server --remote-send '\'':source ~/.vimrc<cr>'\''; done'

# Ripgrep
rgl() {
  rg --color=always $@ | less -R
}

fzcp() {
  fzf -m --tac $@ | xclip -sel clip
}

# macOS
if [[ "$os" == 'Darwin' ]]; then
  # Fix the macOS pasteboard when it breaks
  alias fixpboard='pkill -9 pboard'

  alias ip-eth="ipconfig getifaddr en0"
  alias ip-wifi="ipconfig getifaddr en1"
fi

is_gnu_sed() {
  sed --version >/dev/null 2>&1
}

alias s='sudo'

# Key bindings & related config
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

bindkey '^f' reset-prompt

# Default 400ms delay after ESC is too slow. Increase this value if this breaks
# other commands that depend on the delay.
export KEYTIMEOUT=1 # 100 ms

# Completion
# Allow tab completion to match hidden files always
setopt globdots

# Misc
if command -v eza &> /dev/null; then
  # -F cannot come before other bundled single-char flags
  alias ls='eza -alF --git --group-directories-first --time-style=long-iso'
  alias l=ls
  alias ld='ls -D'
  alias tree='eza -alTF --git --time-style=long-iso'
  alias t=tree
elif command -v exa &> /dev/null; then
  alias ls='exa -aFl --git --group-directories-first --time-style=long-iso'
  alias l=ls
  alias ld='ls -D'
  alias tree='exa -aFlT --git --time-style=long-iso'
  alias t=tree
else
  alias ls='ls -Ahlp --color=auto --group-directories-first --hyperlink --time-style=long-iso'
  alias l=ls
  alias ld='ls -Ahl --color=auto --directory --hyperlink --time-style=long-iso'
  alias t=tree
fi

export RIPGREP_CONFIG_PATH="$HOME"'/.ripgreprc'

# fzf keybinds/completion
eval "$(fzf --zsh)"
[ -f "$ZDOTDIR/.fzf.zsh" ] && . "$ZDOTDIR/.fzf.zsh"

# Zsh-autosuggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=1

if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

export FZF_DEFAULT_OPTS='--color=16 --bind "f1:execute(less -f {})"'
# --files: List files, do not search them
# --follow: Follow symlinks
# --hidden: Search hidden paths
# --glob: Additional conditions (exclude .git)
# --no-ignore: Do not respect .gitignore and the like
export FZF_DEFAULT_COMMAND='rg --files --glob "!.git/*" --hidden --no-ignore'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND=altc

alias fzfp='fzf --preview '\''[[ $(file --mime {}) =~ binary ]] &&
                 echo {} is a binary file ||
                 (highlight -O ansi -l {} ||
                  coderay {} ||
                  rougify {} ||
                  cat {}) 2> /dev/null | head -200'\'

fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# OPAM configuration
[ -f "$HOME"/.opam/opam-init/init.zsh ] && . "$HOME"/.opam/opam-init/init.zsh

# mise
if command -v mise > /dev/null 2>&1; then
  eval "$(mise activate zsh)"
  if ! command -v usage > /dev/null 2>&1; then
    mise use -g usage
  fi
fi

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
for dump in "$ZSH_CACHE_DIR"/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# Load any available Bash completions.
autoload -U +X bashcompinit && bashcompinit

# Seems this needs to go after all calls to compinit.
# Side note: I have no idea which compinit calls are correct to have.
enable-fzf-tab

load_tmux_user_env() {
  if [ -n "$TMUX" ]; then
    for var in $(tmux show-environment | sed -n '/^TMUX_USER_ENV_/ s/^TMUX_USER_ENV_//p'); do
      export $var
    done
  fi
}
load_tmux_user_env
add-zsh-hook preexec load_tmux_user_env

# Print ellipsis while completing, and load Tmux user variables before completing.
expand-or-complete-custom() {
  # https://github.com/ohmyzsh/ohmyzsh/blob/02d07f3e3dba0d50b1d907a8062bbaca18f88478/lib/completion.zsh#L62
  print -Pn "%F{red}…%f"
  load_tmux_user_env
  zle fzf-tab-complete
  zle redisplay
}

zle -N expand-or-complete-custom
bindkey -M emacs "^I" expand-or-complete-custom
bindkey -M viins "^I" expand-or-complete-custom
bindkey -M vicmd "^I" expand-or-complete-custom

[ -f "$ZDOTDIR"/.zsh-work ] && . "$ZDOTDIR"/.zsh-work

typeset -A global_aliases
export global_aliases=(
  ['@q']='2> /dev/null'
  ['@qq']='>/dev/null 2>&1'
  ['@errout']='2>&1'
  ['@kshell']='sh -c "echo '\''$(base64 -i ~/.kshellrc)'\'' | base64 -d > /tmp/.bashrc && exec bash --rcfile /tmp/.bashrc"'
)

if command -v abbr > /dev/null 2>&1; then
  ABBR_SET_EXPANSION_CURSOR=1
  ABBR_EXPANSION_CURSOR_MARKER='#'
  ABBR_REGULAR_ABBREVIATION_SCALAR_PREFIXES=('man ' 'noglob ' 'sudo ' 'watch ' 'which ')
  ABBR_REGULAR_ABBREVIATION_GLOB_PREFIXES=('-* ')

  typeset -A abbr_abbreviations
  export abbr_abbreviations=(
    ['a']='apt'
    ['ai']='apt install'
    ['apt i']='apt install'
    ['aiy']='apt install -y'
    ['apt iy']='apt install -y'
    ['apt install y']='apt install -y'
    [d]=docker
    [dv]='dirs -v'
    [e]=emacs
    [fzfcp]='fzf #| '"$(echo $clip)"
    [fzfd]='f -t d | fzf'
    [g]=git
    [k]=kubectl
    ['kubectl e']='kubectl exec $pod -it --'
    ['kubectl gp']='kubectl get pods'
    ['kubectl g']='kubectl get'
    ['kubectl get p']='kubectl get pods'
    ['kubectl l']='kubectl logs -c app $pod'
    ['kubectl lf']='kubectl logs -c app --tail=20 -f $pod'
    ['kubectl pf']='kubectl port-forward services/$service 8080:$port'
    [l]=ls
    [m]=mise
    [s]=sudo
    [t]=tree
    [dts]='date +"%Y-%m-%dT%H:%M:%S"'
    [v]=vim
    [wa]='watch -c'
    [wh]=which
  )

  abbrs=$(abbr list-abbreviations)
  for abbreviation phrase in ${(@kv)abbr_abbreviations}; do
    if [[ ! "$abbrs" =~ "\"$abbreviation\"" ]]; then
      abbr "$abbreviation"="$phrase"
    fi
    if [[ ! "$abbrs" =~ "\"@$abbreviation\"" ]]; then
      abbr -g "@$abbreviation"="$phrase"
    fi
  done
  unset abbrs
  unset abbr_abbreviations

  global_abbrs=$(abbr list-abbreviations)
  for abbreviation phrase in ${(@kv)global_aliases}; do
    if [[ ! "$global_abbrs" =~ "\"$abbreviation\"" ]]; then
      abbr -g "$abbreviation"="$phrase"
    fi
  done
  unset global_abbrs
  unset global_aliases

  bindkey "^E" abbr-expand
else
  for abbreviation phrase in ${(@kv)global_aliases}; do
    alias -g "$abbreviation"="$phrase"
  done
fi
unset global_aliases

repl() {
  : ${1:?repl needs a language name (js, python2, ruby, etc).}
  case $1 in
    node|javascript|js)
      node;;
    java)
      jshell;;
    python)
      python;;
    python2)
      python2;;
    python3)
      python3;;
    ruby)
      if command -v rbenv &> /dev/null; then
        if rbenv which pry > /dev/null 2>&1; then
          pry
        else
          irb
        fi
      else
        if command -v pry > /dev/null 2>&1; then
          pry
        else
          irb
        fi
      fi;;
    *)
      echo 'Unrecognised language. Pick one of: node|javascript|js, java, python[2|3], ruby'
      return 1;;
  esac
}

unset os

export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
[[ ! -f ~/.config/zsh/.p10k-tmux.zsh ]] || source ~/.config/zsh/.p10k-tmux.zsh

# zprof
# zmodload -u zsh/zprof
