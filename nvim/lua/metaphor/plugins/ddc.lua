local fn = vim.fn
return {
	{
		"Shougo/ddc.vim",
		version = "^0.4.0",
	},
	{
		"Shougo/ddc-ui-pum",
	},
	{
		"Shougo/pum.vim",
		config = function()
			fn["pum#set_option"]({
				auto_select = true,
				preview_border = "single",
				highlight_normal_menu = "Normal",
				offset_cmdcol = 1,
				offset_cmdrow = 1, -- カーソルのすぐ下に表示
				max_height = 5, -- 表示する最大項目数を5に設定
				-- min_width = 20, -- 最小幅を設定して見やすくする
				direction = "below", -- カーソルの下に表示
				border = "rounded", -- ボーダーを追加（丸み付き）
				padding = true, -- 内部のパディングを有効化
				highlight_scrollbar = "PmenuSbar", -- スクロールバーのハイライト
				highlight_selected = "PmenuSel", -- 選択項目のハイライト
				-- item_orders = { "abbr", "kind" }, -- menu を削除
				item_orders = { "abbr" }, -- menu を削除
				max_columns = { kind = 0 }, -- kind ｶﾗﾑも非表示にする場合
				highlight_columns = { kind = "" }, -- kind カラムのハイライトを削除
			})
		end,
	},
}
