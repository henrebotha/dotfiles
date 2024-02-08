# Setup fzf
# ---------
if [[ ! "$PATH" == */home/hbotha/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/hbotha/.fzf/bin"
fi

if [[ $(uname) == 'Darwin' ]]; then
  fzf_keybinds_path=/opt/homebrew/opt/fzf
else
  fzf_keybinds_path="$HOME"/.fzf
fi

[ -f $fzf_keybinds_path/shell/key-bindings.zsh ] && . $fzf_keybinds_path/shell/key-bindings.zsh
