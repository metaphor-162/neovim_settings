-- このプラグインは、Neovimのタブラインを拡張し、バッファをタブとして表示するための機能を提供します。
-- また、nvim-web-deviconsプラグインに依存しており、アイコンの表示にも対応しています。
return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			separator_style = "slant",
		},
	},
}
