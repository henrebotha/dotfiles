# Functionality for displaying normal mode indicator in Vi mode.
function zle-line-init zle-keymap-select {
  local visual_mode="%{$fg[green]%}N"
  local prompt_char="${${KEYMAP/vicmd/$visual_mode}/(main|viins)/»}"
  # Make prompt_char red if the last executed command failed. This needs to be
  # here because outside the function body, precedence breaks it. ¯\_(ツ)_/¯
  return_status="%(?:%{$fg[cyan]%}$prompt_char:%{$fg[red]%}$prompt_char)"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
# End Vi mode functionality

# Detect git repo
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
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
  if [[ work_in_progress ]]; then
    g_str+="%{$fg[red]%}$(work_in_progress) "
  fi
  echo $g_str
}
# End git functionality

vagrant_string() {
  # echo "%{$fg_bold[white]%}$H_PROMPT_VAGRANT_UP "
}

VIRTUAL_ENV_DISABLE_PROMPT=true

# http://web.cs.elte.hu/zsh-manual/zsh_15.html#SEC53 search for PS1
local username="%{$fg[magenta]%}%n"
local path_string="%{$fg[yellow]%}%3c"
local date_string=$(date +'%Y-%m-%d %H:%M:%S')

precmd() {
  # We do it here so that it _doesn't_ update on zle reset-prompt
  date_string=$(date +'%Y-%m-%d %H:%M:%S')
}

# TMOUT=1
# TRAPALRM() { zle reset-prompt }

# We keep the prompt as a single var, so that reset-prompt redraws the whole thing
PROMPT='${date_string} ${username} ${path_string} $(git_string)$(vagrant_string)%{$reset_color%}
${return_status} %{$reset_color%}'

# Override oh-my-zsh vi-mode plugin prompt
RPS1=''
