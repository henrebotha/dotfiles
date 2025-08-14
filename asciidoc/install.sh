#! /usr/bin/env sh

# Ensure this is run from the directory the script is in
cd "${0%/*}" || exit
mkdir -p "$HOME"/.local/share/asciidoc
stow . -t "$HOME"/.local/share/asciidoc
