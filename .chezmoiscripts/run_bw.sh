#!/bin/sh

if [ -n "$BW_SESSION" ]; then
  echo "BW_SESSION found."
  printf "%s\n" "$(tput setaf 8)An unlock prompt will follow if BW_SESSION is invalid.$(tput sgr0)"
else
  status="$(bw status | jq -r '.status')"
  case $status in
    locked)
      echo 'Bitwarden is locked. Unlock:'
      export BW_SESSION="$(bw unlock)"
      ;;
    unauthenticated)
      echo 'Bitwarden is not authenticated. Log in:'
      export BW_SESSION="$(bw login --raw)"
      ;;
    *)
      printf "%s\n" "$(tput setaf 2)Bitwarden is unlocked.$(tput sgr0)"
      ;;
  esac
fi
