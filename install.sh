#! /usr/bin/env sh

BINDIR=~/.local/bin sh -c "$(curl -fsLS get.chezmoi.io)"
chezmoi apply
