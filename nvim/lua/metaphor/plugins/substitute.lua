-- このプラグインは、Neovimで高度な置換操作を行うための機能を提供します。
-- モーション、行単位、行末まで、ビジュアルモードでの置換など、様々な方法で置換を行うことができます。
-- また、置換操作をより直感的かつ効率的に行うためのキーマッピングを設定することもできます。
return {
	"gbprod/substitute.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local substitute = require("substitute")

		substitute.setup()

		-- キーマップを設定
		local keymap = vim.keymap -- 簡潔にするため

		-- モーションを使用して置換
		vim.keymap.set("n", "s", substitute.operator, { desc = "モーションを使用して置換" })

		-- 行を置換
		vim.keymap.set("n", "ss", substitute.line, { desc = "行を置換" })

		-- 行末まで置換
		vim.keymap.set("n", "S", substitute.eol, { desc = "行末まで置換" })

		-- ビジュアルモードで置換
		vim.keymap.set("x", "s", substitute.visual, { desc = "ビジュアルモードで置換" })
	end,
}
