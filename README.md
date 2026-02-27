# Public Vim Dotfiles

A lightweight, secure, and purely Vim-focused configuration repository designed for deployment on remote servers.

## Objective
This project provides a clean Vim/Neovim setup by:
- Removing AI integrations (e.g., Copilot) and sensitive credentials.
- Providing an automated, zero-interaction shell script for deployment.
- Keeping configurations modular and easy to maintain.

## Environment Variables

The following environment variables can be used to customize the behavior of the configuration and installation script:

| Variable | Description | Default |
| :--- | :--- | :--- |
| `IS_IPAD` | Set to `1` to disable LSP and heavy plugins (recommended for iPad/mobile environments). | Not set |
| `ZETTELKASTEN_HOME` | Absolute path to your Zettelkasten/Obsidian notes directory. | `$HOME/dotfiles/zettelkasten` |
| `BACKUP_SUFFIX` | Suffix added to existing config files during backup by `install.sh`. | `.backup` |
| `REPO_ROOT` | (Used by `install.sh`) The path to this repository if running from a different location. | Current directory |

## Setup

1. Clone the repository.
2. Run `sh install.sh`.

### Installation details
`install.sh` will:
- (Optional) Install Xcode Command Line Tools & Homebrew.
- (Optional) Install Neovim, ripgrep, fd, and other essential tools.
- Create symlinks for `~/.config/nvim` and `~/.vim`.
- Bootstrap `lazy.nvim` and `vim-plug`.

## Usage

### Neovim
Simply run `nvim`. Plugins will be installed automatically on the first run via `lazy.nvim`.

### Vim
Run `vim` and execute `:PlugInstall` to install plugins.
