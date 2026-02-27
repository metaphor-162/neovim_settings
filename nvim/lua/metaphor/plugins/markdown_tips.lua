return {
	"nvim-telescope/telescope.nvim",
	keys = {
		{
			"<leader>dm",
			function()
				require("metaphor.modules.markdown_tips").picker()
			end,
			mode = "v",
			desc = "Markdown Tips Picker",
		},
	},
}
