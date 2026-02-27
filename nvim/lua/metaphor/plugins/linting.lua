-- このプラグインは、Neovimでリアルタイムにリンティングを行うための機能を提供します。
-- 特定のイベント（ファイルを開いたとき、保存したとき、挿入モードを抜けたときなど）に応じて、
-- 設定されたリンターを実行し、エラーや警告を表示します。
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- ファイルタイプごとにリンターを設定
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
		}

		-- リンティングを実行するイベントを設定
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- リンティングを手動で実行するキーマップを設定
		vim.keymap.set("n", "<leader>ln", function()
			lint.try_lint()
		end, { desc = "現在のファイルのリンティングをトリガー" })
	end,
}
