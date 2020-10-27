function prompt_char {
  # $1 is the exit code of the most recent command.
  echo -n "%{"
  case $KEYMAP in
    vicmd)
      case "$1" in
        0) echo -n "%F{green}";;
        *) echo -n "%F{yellow}";;
      esac;
      echo '%}›';;
    viins|main)
      case "$1" in
        0) echo -n "%F{cyan}";;
        *) echo -n "%F{red}";;
      esac;
      echo '%}»';;
  esac
}

# Functionality for displaying normal mode indicator in Vi mode.
function zle-line-init zle-keymap-select {
  return_status="$(prompt_char $exit_code)"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
# End Vi mode functionality

parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}
function fast_git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}
ZSH_THEME_GIT_PROMPT_DIRTY="%{%F{blue}%}*"
git_string() {
  local git_where="$(parse_git_branch)"
  if [[ ! -n "$git_where" ]]; then
    return
  fi
  local git_prompt_info="$(fast_git_prompt_info)"
  local g_str="%{%F{green}%}$git_prompt_info "
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    g_str+="%{%F{red}%}WIP "
  fi
  if $(git stash list 2>/dev/null | grep -q -c "on $(echo $git_prompt_info | cut -d/ -f2-)"); then
    g_str+="%{%F{yellow}%}(s) "
  fi
  echo $g_str
}
# End git functionality

vagrant_string() {
  # echo "%{$fg_bold[white]%}$H_PROMPT_VAGRANT_UP "
}

VIRTUAL_ENV_DISABLE_PROMPT=true

jobs_status() {
  echo "%1(j.%{%F{blue}%}zᶻ %j%{%f%} .)"
}

# http://web.cs.elte.hu/zsh-manual/zsh_15.html#SEC53 search for PS1
local username="%{%F{magenta}%}%n"
local path_string="%4(c|%{%F{green}%}…%{%F{yellow}%}/|)%{%F{yellow}%}%3c"
local date_string=$(date +'%Y-%m-%d %H:%M:%S')
local jobs_string=$(jobs_status)

precmd() {
  exit_code=$?
  # We do it here so that it _doesn't_ update on zle reset-prompt
  date_string=$(date +'%Y-%m-%d %H:%M:%S')
  jobs_string=$(jobs_status)
}

# TMOUT=1
# TRAPALRM() { zle reset-prompt }

# We keep the prompt as a single var, so that reset-prompt redraws the whole thing
PROMPT='${date_string} ${username} ${path_string} $(git_string)${jobs_string}$(vagrant_string)%f
${return_status} %{%f%}'

# Override oh-my-zsh vi-mode plugin prompt
RPS1=''