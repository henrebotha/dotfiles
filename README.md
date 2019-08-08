# dotfiles

My various configs.

## Instructions

1. Clone the repo by doing `git clone https://github.com/henrebotha/dotfiles`.
2. Head to your home directory by doing `cd ~`.
3. Make a symlink for each file by doing `ln -s ~/path/to/dotfiles/filename .filename` per file.
  * `karabiner.json` is different - it goes in `~/.config/karabiner/karabiner.json`.
  * `.vim/ftplugin` (a directory) should live at `~/.vim/ftplugin`.
  * `kakrc` should go in `$(which kak)/../share/kak/kakrc`.
  * The contents of `xorg.conf.d` should go in `/etc/X11/xorg.conf.d`.

## What goes where?

https://unix.stackexchange.com/a/71258/123342

TL;DR:

1. `.zshenv` contains variables like `$PATH` and `$EDITOR` which need to be available to other programs.
2. `.zprofile` is like `.zlogin`; an alternative for people used to ksh. Not intended to be used together.
3. `.zshrc` is for interactive shell configuration. Prompt, colours, etc.
4. `.zlogin` is often used to start X using `startx`. Some systems start X on boot, so this file is not always very useful.
5. `.zlogout` is sometimes used to clear and reset the terminal.

From https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/:

+----------------+-----------+-----------+------+
|                |Interactive|Interactive|Script|
|                |login      |non-login  |      |
+----------------+-----------+-----------+------+
|/etc/zshenv     |    A      |    A      |  A   |
|~/.zshenv       |    B      |    B      |  B   |
|/etc/zprofile   |    C      |           |      |
|~/.zprofile     |    D      |           |      |
|/etc/zshrc      |    E      |    C      |      |
|~/.zshrc        |    F      |    D      |      |
|/etc/zlogin     |    G      |           |      |
|~/.zlogin       |    H      |           |      |
|~/.zlogout      |    I      |           |      |
|/etc/zlogout    |    J      |           |      |
+----------------+-----------+-----------+------+
