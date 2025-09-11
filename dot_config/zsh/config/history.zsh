histdir="$XDG_DATA_HOME"/zsh
if ! [ -d "$histdir" ]; then
  mkdir -p "$histdir"
fi

setopt interactive_comments

# Don't expand history inline.
setopt hist_verify

# Store history & share it across sessions.
setopt share_history
export HISTSIZE=1000000000
export SAVEHIST=1000000000

export HISTFILE="$histdir"/.zsh_history
unset histdir
# Record timestamps.
setopt extended_history
# When looking up history, ignore duplicates.
setopt hist_find_no_dups
