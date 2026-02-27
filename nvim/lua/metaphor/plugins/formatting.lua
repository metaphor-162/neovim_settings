-- このプラグインは、Neovimでコードフォーマットを管理するためのプラグインです。
-- 複数のフォーマッターを統合し、ファイルタイプごとにフォーマッターを設定できます。
-- また、保存時に自動的にフォーマットを実行する機能も提供しています。
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false, -- 保存時に同期的に実行（完了するまで保存を待機）
				timeout_ms = 3000, -- タイムアウトを3秒に延長（Prettier等の起動待ち対策）
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			})
		end, { desc = "ファイルまたは範囲をフォーマットする（ビジュアルモードの場合）" })
	end,
}
