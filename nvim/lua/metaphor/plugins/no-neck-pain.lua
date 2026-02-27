return {
	"shortcuts/no-neck-pain.nvim",
	event = "VimEnter",
	cond = function()
		vim.api.nvim_set_keymap("n", "<Leader>np", ":NoNeckPain<CR>", { silent = true, noremap = true })
		return not vim.g.vscode
	end,
	config = function()
		vim.schedule(function()
			require("no-neck-pain").setup({
				width = 100, -- Set the desired width for the centered buffer
			})
		end)
	end,
}
