#! /usr/bin/env sh

# Ensure this is run from the directory the script is in
cd "${0%/*}" || exit

config_file=.config/atuin/config.toml

# Atuin always ensures a default config file is created if none exists. This
# complicates our install process. Thus, we will do the following:
# 1. Check if we have uncommitted changes to config.toml, and abort if so.
# 2. Adopt the existing file into Stow.
# 3. Reset the newly-adopted file to match what's committed in this repo.
if ! git diff -s --exit-code "$config_file"; then
  echo 'Error: config.toml has uncommitted changes. Proceeding will result in those changes being lost.'
  exit 1
fi
stow . --adopt -t "$HOME" --no-folding
git restore "$config_file"
