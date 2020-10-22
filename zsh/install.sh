#! /usr/bin/env sh

# Ensure this is run from the directory the script is in
cd "${0%/*}"
stow . -t $HOME --no-folding
