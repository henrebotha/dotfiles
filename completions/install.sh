#! /usr/bin/env sh

# Ensure this is run from the directory the script is in
cd "${0%/*}"
mkdir -p "$ZDOTDIR"/completions
stow . -t "$ZDOTDIR"/completions
