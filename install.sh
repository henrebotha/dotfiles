#! /usr/bin/env sh

# stow completions
# stow fish
stow git --dotfiles -t $HOME
stow hg -t $HOME
# stow kakoune
# stow karabiner-elements
stow kitty -t $HOME/.config/kitty
stow mysql -t $HOME
stow ruby -t $HOME
stow shell -t $HOME
# stow xfce
# stow xorg.conf.d
stow zsh -t $HOME
