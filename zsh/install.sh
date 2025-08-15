#! /usr/bin/env sh

# Ensure this is run from the directory the script is in
cd "${0%/*}" || exit

set -x

echo $HOME
echo $PWD
echo $ZDOTDIR

if command -v stow >/dev/null 2>&1; then
    stow . -t "$HOME" --no-folding
else
    mkdir -p "$HOME/.config"
    ln -sf "$PWD/.config/zsh" "$HOME/.config/zsh"
    ln -sf "$PWD/.zshenv" "$HOME/.zshenv"
fi

# Setting $ZDOTDIR in ~/.zshenv causes future invocations of the shell to not
# source .zshenv, since they will look for it in $ZDOTDIR instead of in $HOME.
# Thus we explicitly make an additional symlink to .zshenv in $ZDOTDIR.
ln -sf "$HOME"/.zshenv "$HOME"/.config/zsh/.zshenv
