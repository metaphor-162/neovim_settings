# Implementation Plan: Build core Vim configuration and installation script

## Phase 1: Repository Setup and Structure [checkpoint: d99a40c]
- [x] Task: Create base directory structure for Vim configs (e.g., `nvim/`, `vim/`). bd69097
- [x] Task: Configure `.gitignore` to explicitly exclude all non-Vim files and credential paths. 9ad57fd
- [x] Task: Write initial `README.md` explaining the purpose of this public dotfiles repository. 6c3b994
- [x] Task: Conductor - User Manual Verification 'Phase 1: Repository Setup and Structure' (Protocol in workflow.md) d99a40c

## Phase 2: Vim Configuration Extraction
- [ ] Task: Extract core Vim settings into `settings.vim` (or `init.lua`).
- [ ] Task: Extract keymaps into `keymaps.vim` (or `keymaps.lua`).
- [ ] Task: Extract plugin list, strictly removing AI/Auth-related plugins.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Vim Configuration Extraction' (Protocol in workflow.md)

## Phase 3: Installation Script Development
- [ ] Task: Write `install.sh` to safely backup existing `.vimrc`/`.config/nvim`.
- [ ] Task: Implement symlinking logic in `install.sh` to link repo files to target destinations.
- [ ] Task: Implement automated plugin manager installation (e.g., vim-plug or lazy.nvim) in the script.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Installation Script Development' (Protocol in workflow.md)