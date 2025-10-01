#!/bin/sh

set_session() {
  if which mise > /dev/null 2>&1; then
    mkdir -p ~/.config/mise/conf.d
    touch ~/.config/mise/conf.d/bw.toml
    mise set --file ~/.config/mise/conf.d/bw.toml BW_SESSION="$1"
  else
    echo BW_SESSION="$1"
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
      set_session "$(bw unlock)"
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
