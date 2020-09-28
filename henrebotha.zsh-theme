function prompt_char {
  # $1 is the exit code of the most recent command.
  echo -n "%{"
  case $KEYMAP in
    vicmd)
      case $1 in
        0) echo -n "$fg[green]";;
        *) echo -n "$fg[yellow]";;
      esac;
      echo '%}›';;
    viins|main)
      case $1 in
        0) echo -n "$fg[cyan]";;
        *) echo -n "$fg[red]";;
      esac;
      echo '%}»';;
  esac
}

# Functionality for displaying normal mode indicator in Vi mode.
function zle-line-init zle-keymap-select {
  return_status="%{$(prompt_char $exit_code)%}"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
# End Vi mode functionality

# Detect git repo
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}
# Override built-in function with faster version
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}
# Print git info if we're in a repo
ZSH_THEME_GIT_PROMPT_PREFIX=''
ZSH_THEME_GIT_PROMPT_SUFFIX=''
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}*"
git_string() {
  local git_where="$(parse_git_branch)"
  if [[ ! -n "$git_where" ]]; then
    return
  fi
  local g_str="%{$fg[green]%}$(git_prompt_info) "
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    g_str+="%{$fg[red]%}WIP "
  fi
  if $(git stash list 2>/dev/null | grep -q -c "on $(git_prompt_info | cut -d/ -f2-)"); then
    g_str+="%{$fg[yellow]%}(s) "
  fi
  echo $g_str
}
# End git functionality

vagrant_string() {
  # echo "%{$fg_bold[white]%}$H_PROMPT_VAGRANT_UP "
}

VIRTUAL_ENV_DISABLE_PROMPT=true

jobs_status() {
  echo "%1(j.%{$fg[blue]%}zᶻ %j%{$reset_color%} .)"
}

# http://web.cs.elte.hu/zsh-manual/zsh_15.html#SEC53 search for PS1
local username="%{$fg[magenta]%}%n"
local path_string="%4(c|%{$fg[green]%}…%{$fg[yellow]%}/|)%{$fg[yellow]%}%3c"
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
PROMPT='${date_string} ${username} ${path_string} $(git_string)${jobs_string}$(vagrant_string)%{$reset_color%}
${return_status} %{$reset_color%}'

# Override oh-my-zsh vi-mode plugin prompt
RPS1=''
