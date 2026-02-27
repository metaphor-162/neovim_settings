vim.cmd("let g:netrw_liststyle = 3")
vim.cmd("let g:loaded_perl_provider = 0")
vim.g.loaded_ruby_provider = 0 -- Rubyプロバイダーを無効化

local opt = vim.opt -- 簡潔にするため
-- 行番号
opt.relativenumber = true -- 相対的な行番号を表示
opt.number = true -- カーソル行に絶対的な行番号を表示（相対的な行番号がオンの場合）
-- タブとインデント
opt.tabstop = 2 -- タブは2スペース（prettierのデフォルト）
opt.shiftwidth = 2 -- インデント幅は2スペース
opt.expandtab = true -- タブをスペースに展開
opt.autoindent = true -- 新しい行を開始するときに現在の行からインデントをコピー
-- 行の折り返し
opt.wrap = true -- 行の折り返しを有効にする
-- 検索設定
opt.ignorecase = true -- 検索時に大文字小文字を区別しない
opt.smartcase = true -- 検索に混合ケースを含める場合、大文字小文字を区別したい場合と想定
-- カーソル行
opt.cursorline = true -- 現在のカーソル行をハイライト
-- 外観
-- nightflyカラースキームを使用するためにtermguicolorsをオンにする
-- （iterm2または他のトゥルーカラー端末を使用する必要あり）
opt.termguicolors = true
opt.background = "dark" -- ライトまたはダークにできるカラースキームはダークに設定
opt.signcolumn = "yes" -- テキストがシフトしないようにサインカラムを表示
-- バックスペース
opt.backspace = "indent,eol,start" -- インデント、行末、またはインサートモード開始位置でバックスペースを許可
-- クリップボード
opt.clipboard:append("unnamedplus") -- システムのクリップボードをデフォルトのレジスタとして使用
-- ウィンドウの分割
opt.splitright = true -- 垂直ウィンドウを右に分割
opt.splitbelow = true -- 水平ウィンドウを下に分割
-- スワップファイルをオフにする
opt.swapfile = false

-- `vim.o.sessionoptions`に`localoptions`を追加
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
