-- このプラグインは、Neovimで自動的に括弧、引用符、およびその他のペアを挿入および削除するための機能を提供します。
-- また、nvim-cmpプラグインと連携して、補完機能と統合されています。
return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	config = function()
		-- nvim-autopairsをインポート
		local autopairs = require("nvim-autopairs")
		-- autopairsを設定
		autopairs.setup({
			check_ts = true, -- treesitterを有効にする
			ts_config = {
				lua = { "string" }, -- luaのstringトークンにペアを追加しない
				javascript = { "template_string" }, -- javascriptのtemplate_stringトークンにペアを追加しない
				java = false, -- javaではtreesitterをチェックしない
			},
		})
		-- nvim-autopairsの補完機能をインポート
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		-- nvim-cmpプラグイン（補完プラグイン）をインポート
		local cmp = require("cmp")
		-- autopairsと補完が連携するようにする
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
