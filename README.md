# dotfiles

My various configs.

## Instructions

1. Clone the repo by doing `git clone https://github.com/henrebotha/dotfiles`.
2. Head to your home directory by doing `cd ~`.
3. Make a symlink for each file by doing `ln -s ~/path/to/dotfiles/filename .filename` per file.
  * `karabiner.json` is different - it goes in `~/.config/karabiner/karabiner.json`.
  * `.vim/ftplugin` (a directory) should live at `~/.vim/ftplugin`.
  * `kakrc` should go in `$(which kak)/../share/kak/kakrc`.

## What goes where?

https://unix.stackexchange.com/a/71258/123342

TL;DR:

1. `.zshenv` contains variables like `$PATH` and `$EDITOR` which need to be available to other programs. It is always sourced.
2. `.zshrc` is for interactive shell configuration. Prompt, colours, etc.
3. `.zlogin` is sourced at the start of a login shell.
4. `.zprofile` is like `.zlogin` but sourced before `.zshrc` instead of after.
5. `.zlogout` is sometimes used to clear and reset the terminal.
