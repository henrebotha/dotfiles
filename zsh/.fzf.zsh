# Setup fzf
# ---------
if [[ ! "$PATH" == */home/hbotha/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/hbotha/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/hbotha/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/hbotha/.fzf/shell/key-bindings.zsh"
