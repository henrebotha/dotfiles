#! /usr/bin/env sh

if [ -n "$CODESPACES" ]; then
    echo "Running Codespaces-specific install"
    zsh/install.sh
    # shell/install.sh
    exit 0
fi

asciidoc/install.sh
atuin/install.sh
completions/install.sh
emacs/install.sh
fish/install.sh
git/install.sh
hg/install.sh
kakoune/install.sh
karabiner-elements/install.sh
kitty/install.sh
mysql/install.sh
ruby/install.sh
shell/install.sh
tmux/install.sh
vim/install.sh
xfce/install.sh
xorg.conf.d/install.sh
zsh/install.sh
