#!/bin/bash

YES_FLAG=""
while getopts ":y" opt; do
  case ${opt} in
    y ) YES_FLAG="-y" ;;
    \? ) echo "Usage: cmd [-y]" ; exit 1 ;;
  esac
done

ask_yes_no() {
  local prompt="$1"
  if [ -n "$YES_FLAG" ]; then
    return 0
  fi
  read -p "$prompt [Y/n] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    return 0
  else
    return 1
  fi
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
FILE_SRC="$DOTFILES_DIR/files/bash_aliases"
FILE_DEST="$HOME/.bash_aliases"

if ask_yes_no "Update .bash_aliases?"; then
  if [ -f "$FILE_DEST" ]; then
    BACKUP_FILE="${FILE_DEST}.bak.$(date +%F_%T)"
    echo "Backing up existing .bash_aliases to $BACKUP_FILE"
    mv "$FILE_DEST" "$BACKUP_FILE"
  fi
  echo "Copying new .bash_aliases..."
  cp "$FILE_SRC" "$FILE_DEST"
else
  echo "Skipping .bash_aliases update."
fi
