#! /usr/bin/env sh

set -x

# Ensure this is run from the directory the script is in
cd "${0%/*}" || exit
stow . --dotfiles -t "$HOME"/.vim --no-folding
