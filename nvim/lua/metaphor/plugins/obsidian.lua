local zettelkasten_home = os.getenv("ZETTELKASTEN_HOME") or (os.getenv("HOME") .. "/dotfiles/zettelkasten")
vim.o.conceallevel = 2

return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},

	opts = {
		workspaces = {
			{
				name = "personal",
				path = zettelkasten_home,
			},
		},

		finder = "telescope.nvim",
		sort_by = "modified",
		sort_reversed = true,
		follow_url_func = function(url)
			local open_app
			if vim.fn.has("mac") == 1 then
				open_app = "open"
			elseif vim.fn.has("wsl") == 1 then
				open_app = "wslview"
			else
				open_app = "xdg-open"
			end
			vim.fn.jobstart({ open_app, url })
		end,

		-- 画像の保存先ディレクトリ
		image_dir = "images",
        
        -- ★ 明示的にFrontmatter機能を無効化するオプションを追加
        disable_frontmatter = true,

		new_notes_location = "current_dir",

		wiki_link_func = function(opts)
			return require("obsidian.util").wiki_link_id_prefix(opts)
		end,

		------------------------------------------------------------------
		-- ★ ここに書かないと効かない
		------------------------------------------------------------------
		frontmatter = {
			enable = false, -- ← 保存時の frontmatter 自動生成を完全停止
		},

		------------------------------------------------------------------
		-- ★ completion も opts 内に入れる必要がある
		------------------------------------------------------------------
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
	},

	config = function(_, opts)
		require("obsidian").setup(opts)
		
		-- カスタム Frontmatter 管理ロジックを有効化
		-- （保存時に強制的に指定フォーマットに書き換える）
		require("metaphor.modules.frontmatter").setup()
		
		-- 過去ノートの編集制限モジュールを有効化
		require("metaphor.modules.edit_restriction").setup()

		local create_daily_note = require("metaphor.modules.create_daily_note").create_daily_note
		vim.api.nvim_create_user_command("CreateDialyNote", create_daily_note(zettelkasten_home), {})
		create_daily_note(zettelkasten_home)
	end,

	keys = {
		{
			"<leader>zb",
			"<cmd>ObsidianBacklinks<cr>",
			desc = "obsidian - バックリンクを表示",
		},
		{
			"<leader>zo",
			"<cmd>ObsidianOpen<cr>",
			desc = "obsidian - 開く",
		},
		{
			"<leader>zl",
			"<cmd>ObsidianLinks<cr>",
			desc = "obsidian - リンク一覧",
		},
		{
			"<leader>zd",
			"<cmd>CreateDialyNote<cr>",
			desc = "obsidian - デイリーノートを開く/作成",
		},
	},
}
