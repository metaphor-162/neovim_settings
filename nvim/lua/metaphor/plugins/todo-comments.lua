-- このプラグインは、コードコメント内のTODO、HACK、NOTE、FIX、PERFなどのキーワードを
-- ハイライトし、それらのコメントをリストアップして管理することができます。
-- これにより、コードベースの保守性が向上し、タスクやメモを見落とすことを防ぐことができます。
-- また、キーマッピングを設定することで、TODOコメント間の移動も簡単に行えます。
return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local todo_comments = require("todo-comments")

		-- キーマップを設定
		local keymap = vim.keymap -- 簡潔にするため

		-- 次のTODOコメントに移動
		keymap.set("n", "]t", function()
			todo_comments.jump_next()
		end, { desc = "次のTODOコメントに移動" })

		-- 前のTODOコメントに移動
		keymap.set("n", "[t", function()
			todo_comments.jump_prev()
		end, { desc = "前のTODOコメントに移動" })

		todo_comments.setup()
	end,
}
