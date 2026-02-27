#!/bin/bash
set -e

# Configuration
SUFFIX=${BACKUP_SUFFIX:-".backup"}
DOTFILES_DIR=${REPO_ROOT:-$(pwd)}

backup_if_exists() {
    local target=$1
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target to ${target}${SUFFIX}"
        mv "$target" "${target}${SUFFIX}"
    fi
}

symlink_if_needed() {
    local src=$1
    local dest=$2
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        backup_if_exists "$dest"
    fi
    echo "Symlinking $src to $dest"
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
}

echo "Starting Vim configuration installation..."

# Backup and Symlink
symlink_if_needed "$DOTFILES_DIR/vim/settings.vim" "$HOME/.vim/settings.vim"
symlink_if_needed "$DOTFILES_DIR/vim/keymaps.vim" "$HOME/.vim/keymaps.vim"
symlink_if_needed "$DOTFILES_DIR/vim/plugins.vim" "$HOME/.vim/plugins.vim"

symlink_if_needed "$DOTFILES_DIR/nvim/lua/core/options.lua" "$HOME/.config/nvim/lua/core/options.lua"
symlink_if_needed "$DOTFILES_DIR/nvim/lua/core/keymaps.lua" "$HOME/.config/nvim/lua/core/keymaps.lua"
symlink_if_needed "$DOTFILES_DIR/nvim/lua/core/plugins.lua" "$HOME/.config/nvim/lua/core/plugins.lua"

# Create entry points
echo "Creating entry points..."
backup_if_exists "$HOME/.vimrc"
cat <<EOF > "$HOME/.vimrc"
source ~/.vim/settings.vim
source ~/.vim/keymaps.vim
" Plugins (uncomment if vim-plug is installed)
" source ~/.vim/plugins.vim
EOF

# Install vim-plug for Vim
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "Installing vim-plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || echo "Curl failed, skipping vim-plug download."
fi

# Install lazy.nvim for Neovim
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
    echo "Installing lazy.nvim..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH" || echo "Git clone failed, skipping lazy.nvim download."
fi

backup_if_exists "$HOME/.config/nvim/init.lua"
cat <<EOF > "$HOME/.config/nvim/init.lua"
require("core.options")
require("core.keymaps")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "core.plugins" },
  },
})
EOF

echo "Installation (Phase 3: Plugin Managers) complete."
