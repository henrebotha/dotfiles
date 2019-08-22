# exports should go in this file, not .zshrc

# This must happen before zsh-nvm is loaded.
export NVM_LAZY_LOAD=true

# Enable rbenv.
export PATH="$HOME/.rbenv/bin:$PATH"

export PATH="/Applications/Postgres.app/Contents/Versions/9.6/bin:$PATH"

# Don't export TERM! The terminal app should handle this
# export TERM="xterm-256color"

# --files: List files, do not search them
# --follow: Follow symlinks
# --hidden: Search hidden paths
# --glob: Additional conditions (exclude .git)
# --no-ignore: Do not respect .gitignore and the like
export FZF_DEFAULT_COMMAND='rg --files --glob "!.git/*" --hidden --no-ignore'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export LANG=en_GB.utf-8

export PATH="$HOME/.cargo/bin:$PATH"

export EDITOR="vim -X"
