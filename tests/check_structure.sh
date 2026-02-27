#!/bin/bash
if [ -d "nvim" ] && [ -d "vim" ]; then
  echo "Structure correct"
  exit 0
else
  echo "Structure missing"
  exit 1
fi
