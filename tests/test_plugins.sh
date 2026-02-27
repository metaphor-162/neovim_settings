#!/bin/bash
if [ -f "vim/plugins.vim" ]; then
  echo "Plugins correct"
  exit 0
else
  echo "Plugins missing"
  exit 1
fi
