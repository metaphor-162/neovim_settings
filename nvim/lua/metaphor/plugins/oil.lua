-- TODO: sshもできるのか！調査せよ
--
return {
	"stevearc/oil.nvim", -- プラグイン名とリポジトリ
	cond = function()
		vim.api.nvim_set_keymap("n", "<Leader>eo", ":Oil<CR>", { silent = true, noremap = true })
		return not vim.g.vscode
	end,
	config = function()
		require("oil").setup({
			-- デフォルトの設定を使用
			default_file_explorer = true,
			columns = {
				"icon", -- ファイルエクスプローラーにアイコンを表示
			},
			buf_options = {
				buflisted = false, -- バッファをリストに表示しない
				bufhidden = "hide", -- バッファを隠す
			},
			win_options = {
				wrap = false, -- 行の折り返しを無効にする
				signcolumn = "no", -- サインカラムを無効にする
				cursorcolumn = false, -- カーソルカラムを無効にする
				foldcolumn = "0", -- フォールドカラムを無効にする
				spell = false, -- スペルチェックを無効にする
				list = false, -- リスト文字を無効にする
				conceallevel = 3, -- コンシールレベルを3に設定
				concealcursor = "nvic", -- ノーマル、ビジュアル、インサート、コマンドモードでカーソルを隠す
			},
			delete_to_trash = false, -- ファイルをゴミ箱に移動しない
			skip_confirm_for_simple_edits = false, -- 簡単な編集の確認をスキップしない
			prompt_save_on_select_new_entry = true, -- 新しいエントリを選択するときに保存を促す
			cleanup_delay_ms = 2000, -- クリーンアップの遅延時間（ミリ秒）
			lsp_file_methods = {
				timeout_ms = 1000, -- LSPファイルメソッドのタイムアウト（ミリ秒）
				autosave_changes = false, -- 変更を自動保存しない
			},
			constrain_cursor = "editable", -- カーソルを編集可能な領域に制限する
			watch_for_changes = false, -- 変更を監視しない
			keymaps = {
				["g?"] = "actions.show_help", -- ヘルプを表示
				["<CR>"] = "actions.select", -- エントリを選択
				["<C-v>"] = {
					"actions.select",
					opts = { vertical = true }, -- エントリを垂直分割で開く
					desc = "エントリを垂直分割で開く",
				},
				["<C-x>"] = {
					"actions.select",
					opts = { horizontal = true }, -- エントリを水平分割で開く
					desc = "エントリを水平分割で開く",
				},
				["<C-t>"] = {
					"actions.select",
					opts = { tab = true }, -- エントリを新しいタブで開く
					desc = "エントリを新しいタブで開く",
				},
				["<C-p>"] = "actions.preview", -- エントリをプレビュー
				["<C-c>"] = "actions.close", -- エントリを閉じる
				["<C-l>"] = "actions.refresh", -- エントリをリフレッシュ
				["-"] = "actions.parent", -- 親ディレクトリに移動
				["_"] = "actions.open_cwd", -- 現在の作業ディレクトリを開く
				["`"] = "actions.cd", -- ディレクトリを変更
				["~"] = {
					"actions.cd",
					opts = { scope = "tab" }, -- タブスコープでディレクトリを変更
					desc = ":tcdで現在のoilディレクトリに移動",
				},
				["gs"] = "actions.change_sort", -- ソート順を変更
				["gx"] = "actions.open_external", -- 外部アプリケーションを開く
				["g."] = "actions.toggle_hidden", -- 隠しファイルを切り替え
				["g\\"] = "actions.toggle_trash", -- ゴミ箱を切り替え
			},
			use_default_keymaps = true, -- デフォルトのキーマップを使用
			view_options = {
				show_hidden = true, -- 隠しファイルを表示しない
				is_hidden_file = function(name, bufnr)
					return vim.startswith(name, ".") -- '.'で始まるファイルを隠しファイルとする
				end,
				is_always_hidden = function(name, bufnr)
					return false -- 常に隠すファイルはない
				end,
				natural_order = true, -- 自然順序でソート
				case_insensitive = false, -- 大文字小文字を区別するソート
				sort = {
					{ "type", "asc" }, -- タイプで昇順にソート
					{ "name", "asc" }, -- 名前で昇順にソート
				},
			},
			extra_scp_args = {}, -- SCPの追加引数
			git = {
				add = function(path)
					return false -- ファイルをgitに追加しない
				end,
				mv = function(src_path, dest_path)
					return false -- gitでファイルを移動しない
				end,
				rm = function(path)
					return false -- gitからファイルを削除しない
				end,
			},
			float = {
				padding = 2, -- フローティングウィンドウのパディング
				max_width = 0, -- フローティングウィンドウの最大幅
				max_height = 0, -- フローティングウィンドウの最大高さ
				border = "rounded", -- フローティングウィンドウの境界線を丸くする
				win_options = {
					winblend = 0, -- フローティングウィンドウの透明度を0に設定
				},
				preview_split = "auto", -- プレビュー分割を自動に設定
				override = function(conf)
					return conf -- 設定を上書き
				end,
			},
			preview = {
				max_width = 0.9, -- プレビューの最大幅
				min_width = { 40, 0.4 }, -- プレビューの最小幅
				width = nil, -- プレビューのデフォルト幅
				max_height = 0.9, -- プレビューの最大高さ
				min_height = { 5, 0.1 }, -- プレビューの最小高さ
				height = nil, -- プレビューのデフォルト高さ
				border = "rounded", -- プレビューの境界線を丸くする
				win_options = {
					winblend = 0, -- プレビューの透明度を0に設定
				},
				update_on_cursor_moved = true, -- カーソル移動時にプレビューを更新
			},
			progress = {
				max_width = 0.9, -- プログレスの最大幅
				min_width = { 40, 0.4 }, -- プログレスの最小幅
				width = nil, -- プログレスのデフォルト幅
				max_height = { 10, 0.9 }, -- プログレスの最大高さ
				min_height = { 5, 0.1 }, -- プログレスの最小高さ
				height = nil, -- プログレスのデフォルト高さ
				border = "rounded", -- プログレスの境界線を丸くする
				minimized_border = "none", -- 最小化されたプログレスの境界線をなしに設定
				win_options = {
					winblend = 0, -- プログレスの透明度を0に設定
				},
			},
			ssh = {
				border = "rounded", -- SSHの境界線を丸くする
			},
			keymaps_help = {
				border = "rounded", -- キーマップヘルプの境界線を丸くする
			},
		})
	end,
}
