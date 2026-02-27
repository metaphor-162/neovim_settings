-- このプラグインは、Neovimでコメントの追加、削除、トグルを簡単に行うための機能を提供します。
-- また、JoosepAlviste/nvim-ts-context-commentstringプラグインに依存しており、
-- ファイルタイプに応じたコメントの形式を自動的に決定します。
return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- commentプラグインを安全にインポート
		local comment = require("Comment")
		local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
		-- commentを有効にする
		comment.setup({
			-- tsx、jsx、svelte、htmlファイルのコメントのために
			pre_hook = ts_context_commentstring.create_pre_hook(),
		})
	end,
}
