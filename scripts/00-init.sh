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

if ask_yes_no "Initialize directories (~/repos, ~/scripts, ~/projects, ~/venvs)?"; then
  echo "Creating directories..."
  mkdir -p "$HOME/repos"
  mkdir -p "$HOME/scripts"
  mkdir -p "$HOME/projects"
  mkdir -p "$HOME/venvs"
else
  echo "Initialization denied. Exiting."
  exit 1
fi
