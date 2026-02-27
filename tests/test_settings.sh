#!/bin/bash
if [ -f "vim/settings.vim" ]; then
  echo "Settings correct"
  exit 0
else
  echo "Settings missing"
  exit 1
fi
