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

# Bind pgup/pgdn to tmux stuff

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
