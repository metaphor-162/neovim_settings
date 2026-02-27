# Product Guidelines

## Design Principles
- **Simplicity First**: The configuration must remain minimal and avoid over-engineering. Only add what is necessary for a productive text editing experience.
- **Portability**: The setup should work reliably across various Unix-like environments without complex dependencies.
- **Security by Default**: Never include, track, or prompt for sensitive information, credentials, or private keys.
- **Predictability**: Follow standard Vim conventions where possible to ensure the environment feels familiar to most users.

## Code & Configuration Style
- **Modularity**: Organize Vim configurations logically (e.g., `plugins.vim`, `keymaps.vim`, `settings.vim`) rather than a single monolithic `vimrc` or `init.lua` (if Neovim).
- **Documentation**: Provide clear, concise comments above custom keymaps or non-standard configurations to explain their purpose.
- **Shell Scripting Standards**: The installation script must be idempotent, safely handling existing configurations (e.g., backing up existing configs), and clearly logging its progress.

## User Experience (UX)
- **Fast Startup**: Boot time is critical. Lazy-load plugins where appropriate to maintain a snappy experience.
- **Unobtrusive**: The installation process should not block waiting for user input unless absolutely necessary.
- **Visual Clarity**: Use a clean, distraction-free colorscheme that works well in various terminal environments.