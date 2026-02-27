# Specification: Build core Vim configuration and installation script

## Objective
Extract a pure, lightweight Vim configuration from the existing dotfiles, completely removing any AI integrations (like Copilot) and authentication credentials. Create an automated, zero-interaction shell script to deploy this configuration on remote servers.

## Requirements
- **Configuration Parsing:** Review original `/home/fkn93/dotfiles` and extract Vim-specific configs.
- **Plugin Management:** Retain only essential text-editing/navigation plugins.
- **Installation Script:** Create `install.sh` based on `init_mac.sh` but stripped down to only Vim setup.
- **Security:** Ensure zero secrets are tracked.
- **Modularity:** Keep configurations organized logically (e.g., `plugins.vim`, `keymaps.vim`).