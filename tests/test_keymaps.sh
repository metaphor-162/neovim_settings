#!/bin/bash
if [ -f "vim/keymaps.vim" ]; then
  echo "Keymaps correct"
  exit 0
else
  echo "Keymaps missing"
  exit 1
fi
