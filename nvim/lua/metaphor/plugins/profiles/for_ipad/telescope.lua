-- このプラグインは、Neovimでファジー検索を行うためのパワフルなツールです。
-- ファイル、バッファ、ヘルプタグ、Grepパターンなどを高速かつ柔軟に検索することができます。
-- 検索結果は美しいポップアップウィンドウに表示され、プレビューや絞り込みが可能です。
-- また、ユーザーが独自の検索ソースを追加することもできます。
return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		telescope.setup({
			defaults = {
				path_display = { "smart" }, -- パスの表示方法を設定
				mappings = {
					i = {
						["<CR>"] = actions.select_default, -- Enterキーで選択したファイルを開く
						["<C-t>"] = actions.select_tab, -- Ctrl + tで選択したファイルを新規タブで開く
						["<C-v>"] = actions.select_vertical, -- Ctrl + vで選択したファイルを垂直分割で開く
						["<C-x>"] = actions.select_horizontal, -- Ctrl + xで選択したファイルを水平分割で開く
						["<C-k>"] = actions.move_selection_previous, -- 前の結果に移動
						["<C-j>"] = actions.move_selection_next, -- 次の結果に移動
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- 選択した結果をquickfixリストに送信して開く
					},
				},
				layout_config = {
					prompt_position = "top", -- プロンプトを上部に配置
				},
				preview = {
					wrap = true, -- プレビューウィンドウでテキストを折り返す
				},
				sorting_strategy = "ascending", -- 昇順にソート
			},
		})
		telescope.load_extension("fzf") -- fzf拡張を読み込む
		-- キーマップを設定
		local keymap = vim.keymap -- 簡潔にするため
		-- カレントディレクトリ内のファイルをファジー検索
		keymap.set(
			"n",
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			{ desc = "カレントディレクトリ内のファイルをファジー検索" }
		)
		-- 最近使ったファイルをファジー検索
		keymap.set(
			"n",
			"<leader>fr",
			"<cmd>Telescope oldfiles<cr>",
			{ desc = "最近使ったファイルをファジー検索" }
		)
		-- カレントディレクトリ内の文字列を検索
		keymap.set(
			"n",
			"<leader>fs",
			"<cmd>Telescope live_grep<cr>",
			{ desc = "カレントディレクトリ内の文字列を検索" }
		)
		-- カーソル下の文字列をカレントディレクトリ内で検索
		keymap.set(
			"n",
			"<leader>fc",
			"<cmd>Telescope grep_string<cr>",
			{ desc = "カーソル下の文字列をカレントディレクトリ内で検索" }
		)
		-- TODOコメントを検索
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "TODOコメントを検索" })
		-- 現在開いているバッファをファジー検索
		keymap.set(
			"n",
			"<leader>fb",
			"<cmd>Telescope buffers<cr>",
			{ desc = "現在開いているバッファをファジー検索" }
		)
	end,
}
