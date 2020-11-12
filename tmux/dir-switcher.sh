#! /usr/bin/env zsh

set -e
trap 'echo ERROR at $0 $LINENO; return' ERR

# prompt for dir to switch to
# destination=$(find packages -maxdepth 1 -type d | fzf)
destination=$1

# get id of active window
active_window=$(tmux list-windows | rg '\(active\)' | sed 's/:.\+//g')

# list panes in active window
panes=("${(@f)$(tmux list-panes -F '#{pane_index}')}")

# get id of active pane
active_pane=$(tmux list-panes -F '#{pane_active} #{pane_index}' | rg '^1' | sed 's/^1 //g')

for pane in $panes; do
  ./dir-switch.sh $destination $pane
done

tmux select-pane -t $active_pane

exit 0
