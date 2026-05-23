#!/bin/bash

# Default values
YES_FLAG=""

# Parse arguments
while getopts ":y" opt; do
  case ${opt} in
    y )
      YES_FLAG="-y"
      ;;
    \? )
      echo "Usage: cmd [-y]"
      exit 1
      ;;
  esac
done

echo "
 _____        _    __ _ _               
|  __ \      | |  / _(_) |              
| |  | | ___ | |_| |_ _| | ___  ___     
| |  | |/ _ \| __|  _| | |/ _ \/ __|    
| |__| | (_) | |_| | | | |  __/\__ \    
|_____/ \___/ \__|_| |_|_|\___||___/    
|_   _|         | |      | | |          
  | |  _ __  ___| |_ __ _| | | ___ _ __ 
  | | | '_ \/ __| __/ _\` | | |/ _ \ '__|
 _| |_| | | \__ \ || (_| | | |  __/ |   
|_____|_| |_|___/\__\__,_|_|_|\___|_|   
"

echo ""
echo "Starting dotfiles installation..."

# Install git and curl if not present
if ! command -v git &> /dev/null || ! command -v curl &> /dev/null; then
  echo "git or curl not found. Installing..."
  if [ -n "$YES_FLAG" ]; then
    sudo apt-get update
    sudo apt-get install -y git curl
  else
    read -p "Install git and curl? [Y/n] " -n 1 -r < /dev/tty
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
      sudo apt-get update
      sudo apt-get install -y git curl
    else
      echo "git and curl are required. Exiting."
      exit 1
    fi
  fi
fi

# Determine if we are already inside the repo
REPO_URL="https://github.com/alphillips-lab/dotfiles"
DEST_DIR="$HOME/repos/dotfiles"

if [ ! -d "$DEST_DIR" ]; then
  echo "Repository not found at $DEST_DIR. Cloning..."
  mkdir -p "$HOME/repos"
  git clone "$REPO_URL" "$DEST_DIR"
else
  echo "Repository already exists at $DEST_DIR. Pulling latest..."
  cd "$DEST_DIR" || exit 1
  git pull
fi

cd "$DEST_DIR" || exit 1

# Execute scripts in order
if [ -d "scripts" ]; then
  for script in scripts/*.sh; do
    if [ -f "$script" ]; then
      # Make sure the script is executable
      chmod +x "$script"
      echo "Running $script..."
      "$script" $YES_FLAG
      if [ $? -ne 0 ]; then
        echo "Error running $script. Exiting."
        exit 1
      fi
    fi
  done
else
  echo "Error: scripts/ directory not found in $DEST_DIR."
  exit 1
fi

echo "Installation complete!"
