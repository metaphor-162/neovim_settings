#!/bin/bash
if [ ! -f "install.sh" ]; then
  echo "install.sh missing"
  exit 1
fi

# Mock existing config
mkdir -p mock_home/.config/nvim
touch mock_home/.vimrc

# Run with mock home
HOME=$PWD/mock_home bash install.sh --dry-run
if [ -d "mock_home/.config/nvim.backup" ] || [ -f "mock_home/.vimrc.backup" ]; then
  echo "Backup correct"
  rm -rf mock_home
  exit 0
else
  echo "Backup failed"
  rm -rf mock_home
  exit 1
fi
