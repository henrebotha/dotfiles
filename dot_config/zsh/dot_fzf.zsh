# Setup fzf
# ---------
append_path "/home/hbotha/.fzf/bin"

if [[ "${DOTFILES_ENV[OS]}" == 'Darwin' ]]; then
  fzf_keybinds_path=/opt/homebrew/opt/fzf
else
  fzf_keybinds_path="$HOME"/.fzf
fi

[ -f $fzf_keybinds_path/shell/key-bindings.zsh ] && . $fzf_keybinds_path/shell/key-bindings.zsh
