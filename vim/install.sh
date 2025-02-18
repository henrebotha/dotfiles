#! /usr/bin/env sh

# Ensure this is run from the directory the script is in
cd "${0%/*}" || exit
if ! [ -d "$HOME"/.vim ]; then
  mkdir -p "$HOME"/.vim
fi
if ! [ -d "$HOME"/.vim/tmp ]; then
  mkdir -p "$HOME"/.vim/tmp
fi
if ! [ -d "$HOME"/.vim/backup ]; then
  mkdir -p "$HOME"/.vim/backup
fi
stow . --dotfiles -t "$HOME" --no-folding

dot-vim/install.sh
