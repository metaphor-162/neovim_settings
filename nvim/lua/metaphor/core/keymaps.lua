-- リーダーキーをスペースに設定
vim.g.mapleader = " "
local keymap = vim.keymap -- 簡潔にするため
---------------------
-- 一般的なキーマップ
-- -------------------
-- jkでインサートモードを終了
keymap.set("i", "jj", "<ESC>", { desc = "jjでインサートモードを終了" })
-- 検索ハイライトをクリア
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "検索ハイライトをクリア" })
-- レジスタにコピーせずに単一の文字を削除
-- keymap.set("n", "x", '"_x')
-- 数値のインクリメント/デクリメント
keymap.set("n", "<leader>+", "<C-a>", { desc = "数値をインクリメント" }) -- インクリメント
keymap.set("n", "<leader>-", "<C-x>", { desc = "数値をデクリメント" }) -- デクリメント
-- ウィンドウ管理
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "ウィンドウを垂直分割" }) -- ウィンドウを垂直分割
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "ウィンドウを水平分割" }) -- ウィンドウを水平分割
keymap.set("n", "<leader>se", "<C-w>=", { desc = "分割ウィンドウのサイズを均等にする" }) -- 分割ウィンドウの幅と高さを同じにする
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "現在の分割ウィンドウを閉じる" }) -- 現在の分割ウィンドウを閉じる
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "新しいタブを開く" }) -- 新しいタブを開く
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "現在のタブを閉じる" }) -- 現在のタブを閉じる
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "現在のバッファを新しいタブで開く" }) --  現在のバッファを新しいタブに移動
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "前のタブに移動" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "次のタブに移動" })

-- Space系のコマンド
keymap.set("n", "<Space>w", "<cmd>wa<CR>", { desc = "保存" })
keymap.set("n", "<Space>q", "<cmd>wqa<CR>", { desc = "保存して終了" })
keymap.set("n", "<Space>bb", "<cmd>bprev<CR>", { desc = "前のバッファ" })
keymap.set("n", "<Space>bn", "<cmd>bprev<CR>", { desc = "前のバッファ" })
-- keymap.set("n", "<Space>gy", "<cmd>.GBrowse!<CR>", { desc = "GitHubで開く" })
-- keymap.set("v", "<Space>gy", "<cmd>.GBrowse!<CR>", { desc = "GitHubで開く" })
keymap.set("n", "<Space>go", "<cmd>ToGithub<CR>", { desc = "GitHubで開く" })

-- terminal
keymap.set("t", "<C-x>", "<C-\\><C-n>", { desc = "ターミナルモードから抜ける" })
keymap.set("n", "<leader>cp", "<cmd>let @+ = expand('%:p')<CR>", { desc = "ファイルパスをコピー" })

-- window配置変更
--
-- Ctrl+w H (または Ctrl+w h): アクティブなウィンドウを左に移動します。
-- Ctrl+w J (または Ctrl+w j): アクティブなウィンドウを下に移動します。
-- Ctrl+w K (または Ctrl+w k): アクティブなウィンドウを上に移動します。
-- Ctrl+w L (または Ctrl+w l): アクティブなウィンドウを右に移動します。
--
-- また、以下のコマンドを使用してウィンドウを入れ替えることもできます。
--
-- Ctrl+w x: アクティブなウィンドウを隣のウィンドウと入れ替えます。
-- Ctrl+w r: ウィンドウの位置を時計回りに回転させます。
-- Ctrl+w R: ウィンドウの位置を反時計回りに回転させます。
--
-- これらのコマンドを使用することで、Vimのウィンドウを自由に移動・入れ替えることができます。Ctrl+wの後に続く文字を大文字にすると、ウィンドウが移動する方向が逆になります。
-- keymap.set({ "i", "c" }, ";;", [[<Plug>(skkeleton-enable)]], { noremap = false })
keymap.set({ "i", "c" }, [[<C-j>]], [[<Plug>(skkeleton-enable)]], { noremap = false })
-- 補完候補選択
keymap.set({ "i", "c" }, [[<C-f>]], "<cmd>call pum#map#insert_relative(+1)<CR>")
keymap.set({ "i", "c" }, [[<C-b>]], "<cmd>call pum#map#insert_relative(-1)<CR>")
keymap.set({ "i", "c" }, [[<C-y>]], "<cmd>call pum#map#confirm()<CR>")
keymap.set({ "i", "c" }, [[<C-e>]], "<cmd>call pum#map#cancel()<CR>")
keymap.set({ "i", "c" }, [[<PageDown>]], "<cmd>call pum#map#insert_relative_page(+1)<CR>")
keymap.set({ "i", "c" }, [[<PageUp>]], "<cmd>call pum#map#insert_relative_page(-1)<CR>")
-- window配置変更

-- Note Graph
keymap.set("n", "<leader>dy", function()
	require("note_graph").open_graph()
end, { desc = "Open Note Graph" })

keymap.set("n", "<leader>dw", function()
	require("note_graph").open_recent()
end, { desc = "Open Recent Note Graph" })

-- Dashboard
keymap.set("n", "<leader>dr", function()
	require("metaphor.modules.dashboard").open_ranking()
end, { desc = "Open Ranking (Dashboard)" })

keymap.set("n", "<leader>do", function()
	require("metaphor.modules.dashboard").open_todos()
end, { desc = "Open Todo List (Dashboard)" })

keymap.set("n", "<leader>dp", function()
	require("metaphor.modules.dashboard").open_prefixes()
end, { desc = "Open Prefix List (Dashboard)" })

keymap.set(
	"n",
	"<leader>dv",
	"<cmd>Oil /Users/metaphor/dotfiles/.config/nvim/lua/metaphor/<CR>",
	{ desc = "Open nvim config dir with oil" }
)

keymap.set(
	"n",
	"<leader>ds",
	"<cmd>colorscheme ayu<CR><cmd>set background=light<CR>",
	{ desc = "Solarized Light Colorscheme" }
)
