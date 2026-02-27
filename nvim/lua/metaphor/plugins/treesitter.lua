-- このプラグインは、Neovimにツリー構文解析機能を提供します。
-- 言語ごとの構文ハイライト、インデント、折りたたみ、増分選択などの機能を実現します。
-- また、他のプラグインと連携することで、オートタグ補完などの追加機能も利用できます。
-- 幅広い言語に対応しており、コードの可読性と編集効率を大幅に向上させることができます。
-- コードの色分け:
-- コードを見やすくするために、いろんな部分を違う色で表示します。例えば、数字は青、文字列は緑というふうに。これで、コードの構造がわかりやすくなります。
-- コードの構造理解:
-- プログラムの「文法」を理解して、コードの構造を把握します。これは、本の目次のようなもので、コードの全体像がつかみやすくなります。
-- コードの折りたたみ:
-- 長いコードの一部を「折りたたむ」ことができます。必要のない部分を隠して、見たい部分だけに集中できるようになります。
-- コード内の移動:
-- 関数やクラスなど、コードの重要な部分にすばやく移動できます。本のしおりのような役割をします。
-- コードの選択:
-- プログラムの特定の部分（例：関数全体）を簡単に選択できます。これは、コピーや移動をするときに便利です。
-- エラーチェック:
-- コードに間違いがないかチェックしてくれます。宿題のチェックをしてくれる先生のようなものです。
-- コードの自動修正:
-- 簡単な間違いを自動的に直してくれることがあります。例えば、スペルミスなどを修正してくれます。
-- 複数の言語サポート:
-- いろいろなプログラミング言語で使えます。Python、JavaScript、C++など、多くの言語に対応しています。

return {
	"nvim-treesitter/nvim-treesitter",
	tag = "v0.9.2",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- nvim-treesitterプラグインをインポート
		local treesitter = require("nvim-treesitter.configs")
		-- markdownファイルタイプのときのハイライト設定を行う関数
		local function setup_markdown_highlights()
			vim.api.nvim_set_hl(0, "@text.reference", { fg = "#7dcfff", bold = true })
			vim.api.nvim_set_hl(0, "@text.uri", { fg = "#bb9af7", underline = true })
		end

		-- markdownおよびtelekastenファイルを開いたときにハイライトを設定
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "markdown", "telekasten" },
			callback = function()
				setup_markdown_highlights()
				if vim.bo.filetype == "telekasten" then
					-- まずパーサーが利用可能か確認してから登録
					local parsers = require("nvim-treesitter.parsers")
					if parsers.has_parser("markdown") then
						vim.treesitter.language.register("markdown", "telekasten")
					end
					-- markdown_inlineは省略（基本的なマークダウンハイライトはmarkdownパーサーだけでも機能します）
				end
			end,
		})

		-- treesitterを設定
		treesitter.setup({
			-- 構文ハイライトを有効化
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "markdown" },
			},
			-- インデントを有効化
			indent = { enable = true },
			-- オートタグ補完を有効化
			autotag = {
				enable = true,
			},
			-- 以下の言語パーサーがインストールされていることを確認
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"go",
			},
			-- 増分選択を有効化
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
