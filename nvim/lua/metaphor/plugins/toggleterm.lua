-- Name: toggleterm.nvim
return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = false,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})
		local keymap = vim.keymap
		keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "ターミナルのUIを開閉" })
	end,
}

-- このコードは以下の設定を行います：
--
-- 1. `size`: ターミナルの高さを設定します（デフォルトは20）。
-- 2. `open_mapping`: ターミナルを開くためのキーマッピングを設定します（デフォルトは`<c-\>`）。
-- 3. `hide_numbers`: ターミナルウィンドウでの行番号の表示を無効にします。
-- 4. `shade_filetypes`: ターミナル以外のウィンドウを暗くするファイルタイプを指定します（デフォルトは空のリスト）。
-- 5. `shade_terminals`: ターミナル以外のウィンドウを暗くするかどうかを設定します。
-- 6. `shading_factor`: ターミナル以外のウィンドウの暗さを設定します（デフォルトは2）。
-- 7. `start_in_insert`: ターミナルを開いたときにインサートモードで開始するかどうかを設定します。
-- 8. `insert_mappings`: ターミナルでのインサートモードでのマッピングを有効にします。
-- 9. `persist_size`: ターミナルのサイズを維持するかどうかを設定します。
-- 10. `direction`: ターミナルを開く方向を設定します（デフォルトは"float"）。
-- 11. `close_on_exit`: ターミナルが終了したときに自動的に閉じるかどうかを設定します。
-- 12. `shell`: ターミナルで使用するシェルを設定します（デフォルトはvim.o.shell）。
-- 13. `float_opts`: フローティングウィンドウの設定を行います（境界線のスタイル、透明度、ハイライトなど）。
