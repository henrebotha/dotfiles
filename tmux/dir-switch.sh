#! /usr/bin/env zsh

set -e
trap 'echo ERROR at $0 $LINENO; return' ERR

destination=$1
pane=$2

pane_pid=$(tmux list-panes -F '#{pane_index} #{pane_pid}' | rg "^$pane" | sed 's/^.\+ //g')
vim_running=$(ps ar -o cmd= -o stat= --ppid "$pane_pid" | rg '\+' | rg '^vim' || echo '')
if [ -n "$vim_running" ]; then
  # Send Esc then ^C, in case we have some half-typed command
  tmux send-keys -t $pane 'Escape'
  tmux send-keys -t $pane 'C-c'
  tmux send-keys -t $pane -l ":cd $destination"
  tmux send-keys -t $pane 'Enter'
fi

# We need to not only exclude zsh, but also the ps command itself.
process_running=$(ps ar -o cmd= -o stat= --ppid "$pane_pid" | rg '\+' | rg -v '(zsh|ps ar)' || echo '')
if [ -n "$process_running" ]; then
  tmux send-keys -t $pane 'C-z'
  sleep 0.1
fi

tmux send-keys -t $pane -l "cd $destination"
tmux send-keys -t $pane 'Enter'

if [ -n "$process_running" ]; then
  tmux send-keys -t $pane -l 'fg'
  tmux send-keys -t $pane 'Enter'
fi
