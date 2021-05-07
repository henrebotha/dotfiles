# Setup fzf
# ---------
if [[ ! "$PATH" == */home/hbotha/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/hbotha/.fzf/bin"
fi

[ -f "$HOME"/.fzf/shell/key-bindings.zsh ] && . "$HOME"/.fzf/shell/key-bindings.zsh
