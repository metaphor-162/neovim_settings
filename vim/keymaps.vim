" Keymaps extracted from metaphor.core

let mapleader = " "

" jk to exit insert mode
inoremap jj <ESC>

" Clear search highlights
nnoremap <leader>nh :nohl<CR>

" Increment/Decrement
nnoremap <leader>+ <C-a>
nnoremap <leader>- <C-x>

" Window management
nnoremap <leader>sv <C-w>v
nnoremap <leader>sh <C-w>s
nnoremap <leader>se <C-w>=
nnoremap <leader>sx :close<CR>

" Tab management
nnoremap <leader>to :tabnew<CR>
nnoremap <leader>tx :tabclose<CR>
nnoremap <leader>tf :tabnew %<CR>
nnoremap <leader>tp :tabp<CR>
nnoremap <leader>tn :tabn<CR>

" Space-based commands
nnoremap <Space>w :wa<CR>
nnoremap <Space>q :wqa<CR>
nnoremap <Space>bb :bprev<CR>
nnoremap <Space>bn :bnext<CR>

" Terminal
tnoremap <C-x> <C-\><C-n>

" Copy file path
nnoremap <leader>cp :let @+ = expand('%:p')<CR>
