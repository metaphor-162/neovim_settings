#!/bin/bash
if [ -f "README.md" ] && grep -q "Vim" README.md; then
  echo "README correct"
  exit 0
else
  echo "README missing or incorrect"
  exit 1
fi
