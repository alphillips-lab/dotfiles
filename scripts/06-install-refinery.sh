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

if ask_yes_no "Install binary-refinery to ~/venvs/ref?"; then
  echo "Setting up refinery virtual environment..."
  
  # 1) Create virtual environment
  python3 -m venv "$HOME/venvs/ref"
  
  # 2) Activate virtual environment
  source "$HOME/venvs/ref/bin/activate"
  
  # 3) Install refinery
  export REFINERY_PREFIX=r. 
  pip install -U binary-refinery
  
  echo "Refinery installation complete."
else
  echo "Skipping refinery installation."
fi
