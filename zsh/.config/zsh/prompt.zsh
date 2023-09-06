function prompt_char {
  # $1 is the exit code of the most recent command.
  case $KEYMAP in
    vicmd)
      case "$1" in
        0) echo -n "%F{green}";;
        *) echo -n "%F{yellow}";;
      esac;
      echo '›';;
    viins|main)
      case "$1" in
        0) echo -n "%F{cyan}";;
        *) echo -n "%F{red}";;
      esac;
      echo '»';;
  esac
}

# Functionality for displaying normal mode indicator in Vi mode.
function zle-line-init zle-keymap-select {
  prompt_char_with_exit_status="$(prompt_char $exit_code)"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
# End Vi mode functionality

truncate_middle() {
  local max_length=15
  local section_length=7
  local string=$1
  # https://stackoverflow.com/a/10564427/1966418
  local zero='%([BSUbfksu]|([FK]|){*})'
  local length=${#${(S%%)string//$~zero/}}
  if [[ $length -le $max_length ]]; then
    echo $string
    return
  fi
  if [[ $string =~ '([a-zA-Z0-9]+[_\/\-]){2,}' ]]; then
    # Do nice truncation of a UUID or similar hyphen-/underscore-/slash-separated string
    if [[ $string =~ '^[a-zA-Z0-9][_\/\-]([a-zA-Z0-9]+[_\/\-]){2,}' ]]; then
      # Special case for Booking.com b-servicename-123-456 pattern
      local start_chunk=$(sed 's/\([a-zA-Z0-9][_\/\-][a-zA-Z0-9]\+[_\/\-]\).\+$/\1/' <<< $string)
      local end_chunk=$(sed 's/^.\+\([_\/\-]\)/\1/' <<< $string)
      echo $start_chunk…$end_chunk
    else
      local start_chunk=$(sed 's/\([_\/\-]\).\+$/\1/' <<< $string)
      local end_chunk=$(sed 's/^.\+\([_\/\-]\)/\1/' <<< $string)
      echo $start_chunk…$end_chunk
    fi
    return
  fi
  # Fall back to simple truncation of a number of characters
  echo "$string[0,$section_length]…$string[-$section_length,-1]"
}

parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}
parse_git_tag() {
  local tags=$(git tag --points-at HEAD 2> /dev/null)
  local tag=$(head -1 <<< $tags)
  local tag_short="$(truncate_middle $tag)"
  echo -n "$tag_short"
  if [[ $(wc -l <<< $tags) > 1 ]]; then
    echo -n " +"
  fi
}
function git-branch-info() {
  git symbolic-ref --short -q HEAD 2> /dev/null
}
ZSH_THEME_GIT_PROMPT_DIRTY="%{%F{blue}%}*"

function path-to-branch {
  sed 's:--:/:g' <<< "$@"
}

function branch-to-path {
  sed 's:/:--:g' <<< "$@"
}

function branch-matches-path {
  local branch="$(git-branch-info)"
  local path_="$@"
  [[ -n "$branch" ]] && ([[ "$path_" =~ "$(branch-to-path $branch)" ]] || [[ "$path_" =~ "$branch" ]])
}
# local path_string="%4(~|%{%F{green}%}…%{%F{yellow}%}/|)%{%F{yellow}%}%3~"
local path_string="%4(~|%{%F{green}%}…%{%F{yellow}%}/|)%{%F{yellow}%}PATH_START$(print -P '%3~')PATH_END"

git-highlight-root() {
  local path_string_raw="$@"
  local git_root="$(git rev-parse --show-toplevel 2> /dev/null)"
  if [[ ! -n "$git_root" ]]; then
    sed 's:PATH_\(START\|END\)::g' <<< "$path_string_raw"
    return
  fi

  if ! branch-matches-path "$@"; then
    sed 's:PATH_\(START\|END\)::g' <<< "$path_string_raw"
    return
  fi

  local git_root_basename="$(basename $git_root)"

  local path_string_expanded=$(print -P "$path_string_raw")
  sed \
    's:PATH_START\(.\+\b\)\?'"$git_root_basename"'\(\b\/\)\?\(.*\)\?PATH_END:\1%F{green}'"$(git-branch-info)"'%F{yellow}\2\3:' \
    <<< $path_string_expanded
}

git-string() {
  local git_where="$(parse_git_branch)"
  if [[ ! -n "$git_where" ]]; then
    return
  fi

  local g_str

  local git_branch_info="$(git-branch-info)"
  if ! branch-matches-path "$path_string"; then;
    if [[ -n "$git_branch_info" ]]; then
      g_str+="%{%F{green}%}$git_branch_info"
    else
      g_str+="%{%F{red}%}D"
    fi
  fi

  local git_tag_info="$(parse_git_tag)"
  if [ $git_tag_info ]; then;
    g_str+="%{%F{blue}%}#$git_tag_info"
  fi

  local wip_stash
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    wip_stash+="%{%F{red}%}W"
  fi
  local stashes="$(git stash list 2>/dev/null)"
  if [ -n "$stashes" ]; then
    if $(grep -q -c "on $(cut -d/ -f2- <<< $git_branch_info)" <(echo $stashes)); then
      wip_stash+="%{%F{green}%}"
    else
      wip_stash+="%{%F{yellow}%}"
    fi
    wip_stash+="S"
  fi
  if [ -n "$wip_stash" ]; then
    if [ -n "$g_str" ]; then
      g_str+=" "
    fi
    g_str+="$wip_stash"
  fi

  if [ -n "$g_str" ]; then
    g_str+=" "
  fi

  echo $g_str
}
# End git functionality

vagrant_string() {
  # echo "%{$fg_bold[white]%}$H_PROMPT_VAGRANT_UP "
}

VIRTUAL_ENV_DISABLE_PROMPT=true

# http://web.cs.elte.hu/zsh-manual/zsh_15.html#SEC53 search for PS1
local username="%{%F{magenta}%}%n"
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  local hostshort=$(hostname -s 2&> /dev/null)
  if [ -z "$hostshort" ]; then
    # Unknown host, just call it ssh
    hostshort="ssh"
  fi
  username+="%{%F{red}%}@$hostshort"
fi
local date_string=$(date +'%Y-%m-%d %H:%M:%S')
local jobs_string="%1(j.%{%F{blue}%}zᶻ %j%{%f%} .)"

preexec() {
  # Before running any command, update Tmux user variables.
  # FIXME: Tab completion doesn't run preexec, so can tab-complete the wrong value.
  typeset -f load_tmux_user_env > /dev/null && load_tmux_user_env
}

precmd() {
  exit_code=$?
  local git_where="$(parse_git_branch)"
  path_string="%4(~|%{%F{green}%}…%{%F{yellow}%}/|)%{%F{yellow}%}$(git-highlight-root "PATH_START$(print -P '%3~')PATH_END")"

  # We do it here so that it _doesn't_ update on zle reset-prompt
  date_string=$(date +'%Y-%m-%d %H:%M:%S')
}

# TMOUT=1
# TRAPALRM() { zle reset-prompt }

# We keep the prompt as a single var, so that reset-prompt redraws the whole thing
PROMPT='${date_string} ${username} ${path_string} $(git-string)${jobs_string}$(vagrant_string)%f
${prompt_char_with_exit_status} %{%f%}'

# Override oh-my-zsh vi-mode plugin prompt
RPS1=''
