typeset -g POWERLEVEL9K_TMUX_CONNECTED_FOREGROUND=5
typeset -g POWERLEVEL9K_TMUX_DISCONNECTED_FOREGROUND=0

function prompt_tmux() {
  if [[ -n "$TMUX_PANE" ]]; then
    p10k segment -s 'CONNECTED' -t "⋔"
  elif [[ -n "$(tmux ls 2> /dev/null)" ]]; then
    p10k segment -s 'DISCONNECTED' -t "⋔"
  fi
}
