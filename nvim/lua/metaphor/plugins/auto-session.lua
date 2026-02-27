-- このプラグインは、Neovimのセッションを自動的に保存および復元するための機能を提供します。
-- セッションには、開いているバッファ、ウィンドウレイアウト、および他の設定が含まれます。
return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")
		auto_session.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
		})
		local keymap = vim.keymap
		keymap.set(
			"n",
			"<leader>wr",
			"<cmd>SessionRestore<CR>",
			{ desc = "カレントディレクトリのセッションを復元" }
		) -- 現在のディレクトリの最後のワークスペースセッションを復元
		keymap.set(
			"n",
			"<leader>ws",
			"<cmd>SessionSave<CR>",
			{ desc = "auto-sessionのルートディレクトリにセッションを保存" }
		) -- 現在の作業ディレクトリのワークスペースセッションを保存
	end,
}
