-- このプラグインは、Neovim内でファイルエクスプローラ（ツリービュー）を提供します。
-- ファイルやフォルダの階層構造を視覚的に表示し、ファイルの操作（開く、作成、削除など）を行うことができます。
-- また、アイコンを使用してファイルタイプを視覚的に区別することもできます。
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		-- nvim-treeのドキュメントから推奨される設定
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				width = 100, -- ツリーの幅を設定
				relativenumber = true, -- 相対行番号を表示
			},
			-- フォルダの矢印アイコンを変更
			renderer = {
				indent_markers = {
					enable = true, -- インデントマーカーを有効化
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "", -- フォルダが閉じている時の矢印アイコン
							arrow_open = "", -- フォルダが開いている時の矢印アイコン
						},
					},
				},
			},
			-- ウィンドウ分割でエクスプローラがうまく動作するようにwindow_pickerを無効化
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" }, -- 特定のファイルを非表示にするためのフィルタ
			},
			git = {
				ignore = false, -- Gitの無視ファイルを無視しない
			},
		})

		-- キーマップを設定
		local keymap = vim.keymap -- 簡潔にするため

		-- ファイルエクスプローラを切り替え
		keymap.set(
			"n",
			"<leader>ee",
			"<cmd>NvimTreeToggle<CR>",
			{ desc = "ファイルエクスプローラを切り替え" }
		)
		-- 現在のファイルでファイルエクスプローラを切り替え
		keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "現在のファイルでファイルエクスプローラを切り替え" }
		)
		-- ファイルエクスプローラを折りたたむ
		keymap.set(
			"n",
			"<leader>ec",
			"<cmd>NvimTreeCollapse<CR>",
			{ desc = "ファイルエクスプローラを折りたたむ" }
		)

		keymap.set(
			"n",
			"<leader>er",
			"<cmd>NvimTreeRefresh<CR>",
			{ desc = "ファイルエクスプローラを更新" }
		)
	end,
}

-- nvim-treeの主なファイル操作コマンド
-- g? でヘルプを表示できます。
-- nvim-tree mappings                 exit: q
--                     sort by description: s
--  <2-LeftMouse>  Open
--  <2-RightMouse> CD
--  <C-]>          CD
--  <C-E>          Open: In Place
--  <C-K>          Info
--  <C-R>          Rename: Omit Filename
--  <C-T>          Open: New Tab
--  <C-V>          Open: Vertical Split
--  <C-X>          Open: Horizontal Split
--  <BS>           Close Directory
--  <CR>           Open
--  <Tab>          Open Preview
--  .              Run Command
--  -              Up
--  >              Next Sibling
--  <              Previous Sibling
--  B              Toggle Filter: No Buffer
--  C              Toggle Filter: Git Clean
--  D              Trash
--  E              Expand All
--  F              Live Filter: Clear
--  H              Toggle Filter: Dotfiles
--  I              Toggle Filter: Git Ignore
--  J              Last Sibling
--  K              First Sibling
--  L              Toggle Group Empty
--  M              Toggle Filter: No Bookmark
--  O              Open: No Window Picker
--  P              Parent Directory
--  R              Refresh
--  S              Search
--  U              Toggle Filter: Hidden
--  W              Collapse
--  Y              Copy Relative Path
--  a              Create File Or Directory
--  bd             Delete Bookmarked
--  bmv            Move Bookmarked
--  bt             Trash Bookmarked
--  [c             Prev Git
--  c              Copy
--  ]c             Next Git
--  d              Delete
--  [e             Prev Diagnostic
--  ]e             Next Diagnostic
--  e              Rename: Basename
--  f              Live Filter: Start
--  g?             Help
--  ge             Copy Basename
--  gy             Copy Absolute Path
--  m              Toggle Bookmark
--  o              Open
--  p              Paste
--  q              Close
--  r              Rename
--  s              Run System
--  u              Rename: Full Path
--  x              Cut
--  y              Copy Name
