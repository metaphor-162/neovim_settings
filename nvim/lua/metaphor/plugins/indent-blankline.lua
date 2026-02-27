-- このプラグインは、インデントのガイドラインを視覚的に表示するためのプラグインです。
-- ファイル内の各行のインデントレベルに基づいて、縦のガイドラインを表示します。
return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = { char = "┊" },
	},
}
-- python には必需品
