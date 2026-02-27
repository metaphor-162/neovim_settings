local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = { { import = "metaphor.plugins.profiles.for_ipad" } }

-- Only include non-AI/non-private plugins
if os.getenv("IS_IPAD") ~= "1" then
	table.insert(plugins, { import = "metaphor.plugins.lsp" })
	table.insert(plugins, { import = "metaphor.plugins" })
end

require("lazy").setup(plugins, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
	opts = {
		rocks = {
			hererocks = false,
			enabled = false,
		},
	},
})
