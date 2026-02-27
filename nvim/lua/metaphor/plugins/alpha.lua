return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		-- ヘッダーを設定
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}
		-- メニューを設定
		dashboard.section.buttons.val = {
			dashboard.button("1", "  > slate", "<cmd>colorscheme slate<CR>"),
			dashboard.button("2", "  > habamax", "<cmd>colorscheme habamax<CR>"),
			dashboard.button("e", "  > 新規ファイル", "<cmd>ene<CR>"),
			dashboard.button(
				"SPC ee",
				"  > ファイルエクスプローラを切り替え",
				"<cmd>NvimTreeToggle<CR>"
			),
			dashboard.button("SPC ff", "󰱼 > ファイルを検索", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", "  > 単語を検索", "<cmd>Telescope live_grep<CR>"),
			dashboard.button(
				"SPC wr",
				"󰁯  > 現在のディレクトリのセッションを復元",
				"<cmd>SessionRestore<CR>"
			),
			dashboard.button("q", " > Neovimを終了", "<cmd>qa<CR>"),
		}
		-- 設定をalphaに送信
		alpha.setup(dashboard.opts)
		-- alphaバッファでfoldingを無効化
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
