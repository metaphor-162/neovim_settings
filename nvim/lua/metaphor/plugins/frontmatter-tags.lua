return {
	"nvim-telescope/telescope.nvim",
	keys = {
		{
			"<leader>dt",
			function()
				require("metaphor.modules.telescope_tags").picker()
			end,
			desc = "Frontmatter Tags",
		},
	},
}
