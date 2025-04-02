#! /usr/bin/env sh

# Ensure this is run from the directory the script is in
cd "${0%/*}" || exit
if ! [ -d "$HOME"/.emacs.d ]; then
  mkdir -p "$HOME"/.emacs.d
fi
stow . --dotfiles -t "$HOME" --no-folding
