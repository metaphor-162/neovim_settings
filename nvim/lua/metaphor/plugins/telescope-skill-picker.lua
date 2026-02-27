return {
	{
		"metaphor-162/telescope-skill-picker.nvim", -- 公開したリポジトリを指定
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("skill-picker").setup({
				-- SKILL.md があるディレクトリを指定
				skills_dir = "~/dotfiles/.gemini/skills",
			})
			-- キーマップ
			vim.keymap.set("n", "<Leader>sf", ":Telescope skill_picker<CR>", { desc = "Skill Picker" })
		end,
	},
}
