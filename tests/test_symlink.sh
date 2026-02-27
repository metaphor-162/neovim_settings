#!/bin/bash
mkdir -p mock_home

# Run with mock home
REPO_ROOT=$PWD HOME=$PWD/mock_home bash install.sh --dry-run
if [ -L "mock_home/.vim/settings.vim" ] && [ -L "mock_home/.config/nvim/lua/core/options.lua" ]; then
  echo "Symlinks correct"
  rm -rf mock_home
  exit 0
else
  echo "Symlinks failed"
  rm -rf mock_home
  exit 1
fi
