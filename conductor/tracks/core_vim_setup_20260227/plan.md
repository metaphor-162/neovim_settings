# Implementation Plan: Build core Vim configuration and installation script

## Phase 1: Repository Setup and Structure
- [x] Task: Create base directory structure for Vim configs (e.g., `nvim/`, `vim/`). bd69097
- [ ] Task: Configure `.gitignore` to explicitly exclude all non-Vim files and credential paths.
- [ ] Task: Write initial `README.md` explaining the purpose of this public dotfiles repository.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Repository Setup and Structure' (Protocol in workflow.md)

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