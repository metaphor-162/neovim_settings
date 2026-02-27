#!/bin/bash
set -e

# Configuration
SUFFIX=${BACKUP_SUFFIX:-".backup"}

backup_if_exists() {
    local target=$1
    if [ -e "$target" ]; then
        echo "Backing up $target to ${target}${SUFFIX}"
        mv "$target" "${target}${SUFFIX}"
    fi
}

echo "Starting Vim configuration installation..."

# Backup existing configs
backup_if_exists "$HOME/.vimrc"
backup_if_exists "$HOME/.vim"
backup_if_exists "$HOME/.config/nvim"

# Create directories
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.vim"

echo "Installation (Phase 1: Backup) complete."
