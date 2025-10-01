#!/bin/sh

if ! type bw >/dev/null 2>&1; then
  echo 'Installing Bitwarden.'
  case "$(uname -s)" in
    Darwin)
      brew install --quiet bitwarden-cli
      ;;
    Linux)
      if [ -f /etc/arch-release ]; then
        sudo pacman -S bitwarden-cli
      elif [ -f /etc/debian_version ]; then
        sudo apt-get install bitwarden-cli
      elif [ -f /etc/redhat-release ]; then
        yum install bitwarden-cli
      elif [ -f /etc/gentoo-release ]; then
        emerge install bitwarden-cli
      elif [ -f /etc/SuSE-release ]; then
        zypp install bitwarden-cli
      elif [ -f /etc/alpine-release ]; then
        apk install bitwarden-cli
      else
        echo >&2 'Could not identify package manager.'
      fi
      ;;
    *)
      echo >&2 'Could not identify operating system.'
      ;;
  esac
fi

if ! type bw >/dev/null 2>&1; then
  printf "%s\n" "$(tput setaf 3)Proceeding without Bitwarden.$(tput sgr0)"
  printf "%s\n" "$(tput setaf 8)You will need to manually supply data that would be pulled from Bitwarden, but everything should work fine.$(tput sgr0)"
fi

