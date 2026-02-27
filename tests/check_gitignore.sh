#!/bin/bash
touch secret.key
git check-ignore -q secret.key
if [ $? -eq 0 ]; then
  echo "Gitignore correct"
  rm secret.key
  exit 0
else
  echo "Gitignore missing"
  rm secret.key
  exit 1
fi
