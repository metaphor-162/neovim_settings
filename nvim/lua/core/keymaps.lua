vim.g.mapleader = " "

local keymap = vim.keymap

-- General keymaps
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Increment/Decrement
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize window sizes" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Previous tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })

-- Space-based commands
keymap.set("n", "<Space>w", "<cmd>wa<CR>", { desc = "Save all" })
keymap.set("n", "<Space>q", "<cmd>wqa<CR>", { desc = "Save all and quit" })
keymap.set("n", "<Space>bb", "<cmd>bprev<CR>", { desc = "Previous buffer" })
keymap.set("n", "<Space>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Terminal
keymap.set("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Copy file path
keymap.set("n", "<leader>cp", "<cmd>let @+ = expand('%:p')<CR>", { desc = "Copy file path" })
