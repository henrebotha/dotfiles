# Functionality for displaying normal mode indicator in Vi mode.
function zle-line-init zle-keymap-select {
  local visual_mode="%{$fg[green]%}N"
  local prompt_char="${${KEYMAP/vicmd/$visual_mode}/(main|viins)/»}"
  # Make prompt_char red if the last executed command failed. This needs to be
  # here because outside the function body, precedence breaks it. ¯\_(ツ)_/¯
  local return_status="%(?:%{$fg[cyan]%}$prompt_char:%{$fg[red]%}$prompt_char)"
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
git_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "%{$fg[green]%}$(git_prompt_info) %{$fg[red]%}$(work_in_progress)"
}
# End git functionality

VIRTUAL_ENV_DISABLE_PROMPT=true

# http://web.cs.elte.hu/zsh-manual/zsh_15.html#SEC53 search for PS1
local username="%{$fg[magenta]%}%n"
local path_string="%{$fg[yellow]%}%3c"
local date_string="%D{%Y-%m-%d %H:%M:%S}"

precmd() {
  print -rP '${date_string} ${username} ${path_string} $(git_string)'
}

PROMPT='${return_status} %{$reset_color%}'

# Override oh-my-zsh vi-mode plugin prompt
RPS1=''
