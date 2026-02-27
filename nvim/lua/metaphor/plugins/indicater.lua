return {
	{
		"delphinus/skkeleton_indicator.nvim",
		config = function()
			require("skkeleton_indicator").setup({
				eijiHlName = "String",
				hiraHlName = "String",
				kataHlName = "Todo",
				hankataHlName = "Special",
				zenkakuHlName = "LineNr",
				abbrevHlName = "Error",

				eijiText = "a",
				hiraText = "あ",
				kataText = "ア",
			})
		end,
	},
}
