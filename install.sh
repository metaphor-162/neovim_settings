#!/bin/bash
set -e

# Configuration
SUFFIX=${BACKUP_SUFFIX:-".backup"}
DOTFILES_DIR=${REPO_ROOT:-$(pwd)}

# --- Helper Functions ---

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

ask_yes_no() {
    local prompt=$1
    read -p "$prompt (y/n): " answer < /dev/tty
    case "$answer" in
        [yY]*) return 0 ;;
        *) return 1 ;;
    esac
}

# --- Installation Phases ---

echo "======================================="
echo "|      Vim/Neovim Environment Setup    |"
echo "======================================="

# Phase 1: Xcode Command Line Tools (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! xcode-select -p >/dev/null 2>&1; then
        if ask_yes_no "Xcode Command Line Tools をインストールしますか?"; then
            xcode-select --install || true
        fi
    else
        echo "Xcode Command Line Tools はインストール済みです。"
    fi
fi

# Phase 2: Homebrew
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! command -v brew >/dev/null 2>&1; then
        if ask_yes_no "Homebrew をインストールしますか?"; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        fi
    else
        echo "Homebrew はすでにインストールされています。"
    fi
fi

# Phase 3: Core Tools
if ask_yes_no "Neovim や 開発ツール（ripgrep, fd, git等）をインストールしますか?"; then
    echo "Installing tools via Homebrew..."
    brew install neovim ripgrep fd git curl lazygit
fi

# Phase 4: Symbolic Links
if ask_yes_no "設定ファイルのシンボリックリンクを貼りますか?"; then
    echo "Creating symlinks..."
    
    # Neovim
    symlink_if_needed "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
    symlink_if_needed "$DOTFILES_DIR/nvim/lua/core/options.lua" "$HOME/.config/nvim/lua/core/options.lua"
    symlink_if_needed "$DOTFILES_DIR/nvim/lua/core/keymaps.lua" "$HOME/.config/nvim/lua/core/keymaps.lua"
    symlink_if_needed "$DOTFILES_DIR/nvim/lua/core/plugins.lua" "$HOME/.config/nvim/lua/core/plugins.lua"
    
    # Vim
    symlink_if_needed "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
    symlink_if_needed "$DOTFILES_DIR/vim/settings.vim" "$HOME/.vim/settings.vim"
    symlink_if_needed "$DOTFILES_DIR/vim/keymaps.vim" "$HOME/.vim/keymaps.vim"
    symlink_if_needed "$DOTFILES_DIR/vim/plugins.vim" "$HOME/.vim/plugins.vim"
fi

# Phase 5: Plugin Managers Bootstrapping
if ask_yes_no "プラグインマネージャー (vim-plug, lazy.nvim) をセットアップしますか?"; then
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
fi

echo ""
echo "======================================="
echo "|        Installation Complete!       |"
echo "======================================="
echo "Neovim を起動すると自動的にプラグインがインストールされます。"
echo "Vim の場合は起動後に :PlugInstall を実行してください。"
