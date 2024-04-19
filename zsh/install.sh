#! /usr/bin/env sh

# Ensure this is run from the directory the script is in
cd "${0%/*}" || exit
stow . -t "$HOME" --no-folding
# Setting $ZDOTDIR in ~/.zshenv causes future invocations of the shell to not
# source .zshenv, since they will look for it in $ZDOTDIR instead of in $HOME.
# Thus we explicitly make an additional symlink to .zshenv in $ZDOTDIR.
ln -s "$HOME"/.zshenv "$ZDOTDIR"/.zshenv
