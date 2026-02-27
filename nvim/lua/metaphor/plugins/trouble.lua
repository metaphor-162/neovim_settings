-- このプラグインは、Neovimのための強力なトラブルシューティングツールです。
-- 診断メッセージ、参照、TODOコメントなどを一箇所に集約し、簡単にアクセスできるようにします。
-- トラブルリストを使用すると、エラー、警告、TODOなどを一覧で表示し、それらにすばやくジャンプできます。
-- また、クイックフィックスリストやロケーションリストとも統合されており、
-- これらのリストをトラブルリスト内で表示することもできます。
return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	keys = {
		{ "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "トラブルリストを開く/閉じる" },
		{
			"<leader>xw",
			"<cmd>TroubleToggle workspace_diagnostics<CR>",
			desc = "ワークスペースの診断をトラブルで開く",
		},
		{
			"<leader>xd",
			"<cmd>TroubleToggle document_diagnostics<CR>",
			desc = "ドキュメントの診断をトラブルで開く",
		},
		{
			"<leader>xq",
			"<cmd>TroubleToggle quickfix<CR>",
			desc = "クイックフィックスリストをトラブルで開く",
		},
		{
			"<leader>xl",
			"<cmd>TroubleToggle loclist<CR>",
			desc = "ロケーションリストをトラブルで開く",
		},
		{ "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "TODOをトラブルで開く" },
	},
}
