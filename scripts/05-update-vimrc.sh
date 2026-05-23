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
FILE_SRC="$DOTFILES_DIR/files/vimrc"
FILEINIT_SRC="$DOTFILES_DIR/files/init.vim"
VIM_DEST="$HOME/.vimrc"
NVIM_DIR="$HOME/.config/nvim"
NVIM_DEST="$NVIM_DIR/init.vim"

if ask_yes_no "Update .vimrc and init.vim?"; then
  # Vim
  if [ -f "$VIM_DEST" ]; then
    BACKUP_FILE="${VIM_DEST}.bak.$(date +%F_%T)"
    echo "Backing up existing .vimrc to $BACKUP_FILE"
    mv "$VIM_DEST" "$BACKUP_FILE"
  fi
  echo "Copying new .vimrc..."
  cp "$FILE_SRC" "$VIM_DEST"

  # Neovim
  echo "Creating Neovim config directory..."
  mkdir -p "$NVIM_DIR"
  if [ -f "$NVIM_DEST" ]; then
    BACKUP_FILE="${NVIM_DEST}.bak.$(date +%F_%T)"
    echo "Backing up existing init.vim to $BACKUP_FILE"
    mv "$NVIM_DEST" "$BACKUP_FILE"
  fi
  echo "Copying new init.vim..."
  cp "$FILEINIT_SRC" "$NVIM_DEST"
else
  echo "Skipping vim/nvim update."
fi
