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
  read -p "$prompt [Y/n] " -n 1 -r < /dev/tty
  echo
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    return 0
  else
    return 1
  fi
}

if ask_yes_no "Install base packages?"; then
  echo "Installing base packages..."
  sudo apt-get update
  sudo apt-get -y install git curl wget net-tools neovim tmux python3-pip p7zip-full python3-venv
else
  echo "Skipping base packages."
fi
