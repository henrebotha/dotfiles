#!/bin/sh

if [ -n "$CHEZMOI_VERBOSE" ]; then
  echo 'Checking Bitwarden session.'

  set +x
fi

set_session() {
  if which mise > /dev/null 2>&1; then
    if [ ! -d ~/.config/mise/conf.d ]; then
      mkdir -p ~/.config/mise/conf.d
    fi
    if [ ! -f ~/.config/mise/conf.d/bw.toml ]; then
      touch ~/.config/mise/conf.d/bw.toml
    fi
    mise set --file ~/.config/mise/conf.d/bw.toml BW_SESSION="$1"
  else
    printf "%s\n" "$(tput setaf 3)mise not available. Run the following to unlock Bitwarden:$(tput sgr0)"
    echo "export BW_SESSION=\"$1\""
  fi
}

if [ -n "$BW_SESSION" ]; then
  echo "BW_SESSION found."
  printf "%s\n" "$(tput setaf 8)An unlock prompt will follow if BW_SESSION is invalid.$(tput sgr0)"
else
  status="$(bw status | jq -r '.status')"
  case $status in
    locked)
      echo 'Bitwarden is locked. Unlock:'
      set_session "$(bw unlock --raw)"
      ;;
    unauthenticated)
      echo 'Bitwarden is not authenticated. Log in:'
      set_session "$(bw login --raw)"
      ;;
    *)
      printf "%s\n" "$(tput setaf 2)Bitwarden is unlocked.$(tput sgr0)"
      ;;
  esac
fi

if [ -n "$CHEZMOI_VERBOSE" ]; then
  set -x

  echo 'Done.'
fi
