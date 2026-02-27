-- telekasten.lua
local zettelkasten_home = os.getenv("ZETTELKASTEN_HOME") or (os.getenv("HOME") .. "/dotfiles/zettelkasten")

-- Function to convert selected text to markdown link
local function convert_to_markdown()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])
	local title = lines[1]
	local url = lines[2]
	local markdown_link = string.format("[%s](%s)", title, url)
	vim.fn.setline(start_pos[2], markdown_link)
	vim.fn.setline(end_pos[2], "")
end

return {
	"renerocksai/telekasten.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-telekasten/calendar-vim" },

	config = function()
		----------------------------------------------------------------------
		-- 1. Custom user commands
		----------------------------------------------------------------------
		local yank_link = require("metaphor.modules.yank_link").yank_link
		vim.api.nvim_create_user_command("YankLink", yank_link(), {})

		local yank_todays_notes = require("metaphor.modules.yank_todays_obsidian_notes").yank_todays_obsidian_notes
		vim.api.nvim_create_user_command("YankTodaysNotes", yank_todays_notes(zettelkasten_home), {})

		----------------------------------------------------------------------
		-- 2. Telekasten frontmatter 自動生成を完全にブロックするパッチ
		----------------------------------------------------------------------
		--
		-- Telekasten の内部関数 insert_frontmatter_if_missing を空関数に上書き
		-- setup() の【前】に実行することで、autocmd登録時に参照される関数を無力化する
		----------------------------------------------------------------------
		local tk = require("telekasten")
		tk.insert_frontmatter_if_missing = function() end

		----------------------------------------------------------------------
		-- 3. Telekasten Setup
		----------------------------------------------------------------------
		tk.setup({
			home = vim.fn.expand(zettelkasten_home),
			dailies = vim.fn.expand(zettelkasten_home .. "/daily"),
			weeklies = vim.fn.expand(zettelkasten_home .. "/weekly"),
			templates = vim.fn.expand(zettelkasten_home .. "/template"),

			------------------------------------------------------------------
			-- ⚠️ 自動テンプレート生成を完全 OFF にする
			------------------------------------------------------------------
			template_new_note = nil,
			template_new_daily = nil,
			template_new_weekly = nil,
		})

		----------------------------------------------------------------------
		-- Override Calendar Action to open directory with Oil
		----------------------------------------------------------------------
		tk.CalendarAction = function(day, month, year, _, _)
			local target_dir = string.format("%s/dagnetz/%04d/%02d/%02d/", zettelkasten_home, year, month, day)
			vim.cmd("close") -- Close the calendar window
			vim.cmd("tabnew") -- Open a new tab
			vim.cmd("Oil " .. target_dir) -- Open the directory with Oil
		end

		----------------------------------------------------------------------
		-- 4. markdown filetype detection
		----------------------------------------------------------------------
		vim.cmd([[ 
      augroup TelekastenMarkdown
        autocmd!
        autocmd BufRead,BufNewFile */zettelkasten/*.md if &filetype !=# 'oil' | setfiletype telekasten | endif
      augroup END
    ]])
	end,

	------------------------------------------------------------------------
	-- 5. Keymaps
	------------------------------------------------------------------------
	keys = {
		{
			"<leader>zk",
			"<cmd>lua require('telekasten').panel()<cr>",
			desc = "Telekasten - コマンドパレットを表示",
		},
		{
			"<leader>zf",
			"<cmd>lua require('telekasten').find_notes()<cr>",
			desc = "Telekasten - ノートをタイトルで検索",
		},
		{
			"<leader>zg",
			"<cmd>lua require('telekasten').search_notes()<cr>",
			desc = "Telekasten - ノート内を検索",
		},
		{
			"<leader>zz",
			"<cmd>lua require('telekasten').follow_link()<cr>",
			desc = "Telekasten - カーソル下のリンクを辿る",
		},
		{
			"<leader>zn",
			"<cmd>lua require('telekasten').new_note()<cr>",
			desc = "Telekasten - 新しいノートを作成",
		},
		{
			"<leader>zN",
			"<cmd>lua require('telekasten').new_templated_note()<cr>",
			desc = "Telekasten - テンプレートから新しいノートを作成",
		},
		{
			"<leader>zc",
			"<cmd>lua require('telekasten').show_calendar()<cr>",
			desc = "Telekasten - カレンダーを表示",
		},
		{
			"<leader>zp",
			"<cmd>lua require('telekasten').paste_img_and_link()<cr>",
			desc = "Telekasten - 画像を貼り付けてリンクを挿入",
		},
		{
			"<leader>zt",
			"<cmd>lua require('telekasten').toggle_todo()<cr>",
			desc = "Telekasten - TODOステータスを切り替え",
		},
		{
			"<leader>zF",
			"<cmd>lua require('telekasten').find_friends()<cr>",
			desc = "Telekasten - カーソル下のリンクにリンクしているノートを表示",
		},
		{
			"<leader>zI",
			"<cmd>lua require('telekasten').insert_img_link({ i=true })<cr>",
			desc = "Telekasten - 画像リンクを挿入",
		},
		{
			"<leader>za",
			"<cmd>lua require('telekasten').show_tags()<cr>",
			desc = "Telekasten - タグリストを表示",
		},
		{
			"<leader>#",
			"<cmd>lua require('telekasten').show_tags()<cr>",
			desc = "Telekasten - タグリストを再表示",
		},
		{
			"<leader>zr",
			"<cmd>lua require('telekasten').rename_note()<cr>",
			desc = "Telekasten - ノート名変更",
		},
		{
			"<leader>zv",
			"<cmd>lua require('telekasten').switch_vault()<cr>",
			desc = "Telekasten - ボルト切り替え",
		},

		-- Git push
		{
			"<leader>z>",
			function()
				vim.notify("pushing.....")
				local cmd = string.format(
					'cd %s && git add -A && git commit -m "update by cmd" && git push origin main',
					zettelkasten_home
				)
				local output = vim.fn.system(cmd)
				if vim.v.shell_error == 0 then
					vim.notify("Git push succeeded.", vim.log.levels.INFO)
				else
					vim.notify("Git push failed:\n" .. output, vim.log.levels.ERROR)
				end
			end,
			desc = "Telekasten - Commit & push",
		},

		-- Git pull
		{
			"<leader>z<",
			function()
				vim.notify("pulling.....")
				local cmd = string.format("cd %s && git stash && git fetch && git pull origin main", zettelkasten_home)
				local output = vim.fn.system(cmd)
				if vim.v.shell_error == 0 then
					vim.notify("Git pull succeeded.", vim.log.levels.INFO)
				else
					vim.notify("Git pull failed:\n" .. output, vim.log.levels.ERROR)
				end
			end,
			desc = "Telekasten - fetch & pull",
		},

		-- Link yankers
		{
			"<leader>zy",
			"<cmd>YankLink<cr>",
			desc = "Telekasten - 現在ノートへのリンクをヤンク",
		},
		{
			"<leader>zi",
			"<cmd>lua require('telekasten').insert_link()<cr>",
			desc = "Telekasten - リンク挿入",
		},
		{
			"<leader>zm",
			"<cmd>YankTodaysNotes<cr>",
			desc = "Telekasten - 今日のノートを全コピー",
		},

		-- Markdown link converter
		{
			"<leader>zm",
			function()
				convert_to_markdown()
			end,
			desc = "Telekasten - 選択テキストを Markdown link に変換",
		},

		-- Search in dagnetz
		{
			"<leader>df",
			function()
				require("telescope.builtin").find_files({
					cwd = zettelkasten_home .. "/dagnetz",
					no_ignore = true,
					hidden = true,
				})
			end,
			desc = "Telekasten - dagnetz内をファイル名検索",
		},
		{
			"<leader>dg",
			function()
				require("telescope.builtin").live_grep({
					cwd = zettelkasten_home .. "/dagnetz",
					additional_args = function()
						return { "--no-ignore", "--hidden" }
					end,
				})
			end,
			desc = "Telekasten - dagnetz内を文字列検索",
		},

		-- Open today's dagnetz directory
		{
			"<leader>dn",
			function()
				local target_dir = string.format("%s/dagnetz/%s/", zettelkasten_home, os.date("%Y/%m/%d"))
				if vim.fn.isdirectory(target_dir) == 0 then
					vim.fn.mkdir(target_dir, "p")
				end
				vim.cmd("Oil " .. target_dir)
			end,
			desc = "Telekasten - 今日のDagnetzディレクトリを開く",
		},
	},
}
