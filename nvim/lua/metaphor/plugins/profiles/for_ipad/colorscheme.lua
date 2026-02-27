return {
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			local bg = "#011628"
			local bg_dark = "#011423"
			local bg_highlight = "#143652"
			local bg_search = "#0A64AC"
			local bg_visual = "#275378"
			local fg = "#CBE0F0"
			local fg_dark = "#B4D0E9"
			local fg_gutter = "#627E97"
			local border = "#547998"

			require("tokyonight").setup({
				style = "night",
				on_colors = function(colors)
					colors.bg = bg
					colors.bg_dark = bg_dark
					colors.bg_float = bg_dark
					colors.bg_highlight = bg_highlight
					colors.bg_popup = bg_dark
					colors.bg_search = bg_search
					colors.bg_sidebar = bg_dark
					colors.bg_statusline = bg_dark
					colors.bg_visual = bg_visual
					colors.border = border
					colors.fg = fg
					colors.fg_dark = fg_dark
					colors.fg_float = fg
					colors.fg_gutter = fg_gutter
					colors.fg_sidebar = fg_dark
				end,
			})
			-- カーソルの色を設定
			vim.api.nvim_set_hl(0, "Cursor", { fg = "#0A64AC", bg = "#FFFFFF" })

			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])

			-- Markdown見出しをレベル別に塗り分け
			local heading_colors = {
				{ group = "htmlH1", ts = "@text.title.1.markdown", ts_marker = "@text.title.1.marker", color = "#f7768e" }, -- sakura red
				{ group = "htmlH2", ts = "@text.title.2.markdown", ts_marker = "@text.title.2.marker", color = "#e0af68" }, -- amber/orange
				{ group = "htmlH3", ts = "@text.title.3.markdown", ts_marker = "@text.title.3.marker", color = "#9ece6a" }, -- aurora green
				{ group = "htmlH4", ts = "@text.title.4.markdown", ts_marker = "@text.title.4.marker", color = "#7aa2f7" }, -- sky blue
				{ group = "htmlH5", ts = "@text.title.5.markdown", ts_marker = "@text.title.5.marker", color = "#bb9af7" }, -- violet
				{ group = "htmlH6", ts = "@text.title.6.markdown", ts_marker = "@text.title.6.marker", color = "#c0caf5" }, -- pale lavender
			}

			for i, spec in ipairs(heading_colors) do
				vim.api.nvim_set_hl(0, spec.group, { fg = spec.color, bold = true })
				vim.api.nvim_set_hl(0, ("markdownH%d"):format(i), { link = spec.group })
				vim.api.nvim_set_hl(0, ("markdownH%dDelimiter"):format(i), { link = spec.group })
				-- Tree-sitter capture
				vim.api.nvim_set_hl(0, spec.ts, { fg = spec.color, bold = true })
				vim.api.nvim_set_hl(0, spec.ts_marker, { fg = spec.color })
			end

			-- インライン/ブロックコードと引用のアクセント
			local code_bg = "#1b2738"
			local code_fg = "#c0caf5"
			local code_border = "#565f89"
			local quote_bg = "#191f2f"
			local quote_fg = "#7aa2f7"

			local markdown_accents = {
				{ "markdownCode", { fg = code_fg, bg = code_bg } },
				{ "markdownCodeDelimiter", { fg = code_border, bg = code_bg } },
				{ "markdownCodeBlock", { fg = code_fg, bg = code_bg } },
				{ "markdownCodeBlockDelimiter", { fg = code_border, bg = code_bg } },
				{ "@text.literal.markdown", { fg = code_fg, bg = code_bg } },
				{ "@text.literal.block.markdown", { fg = code_fg, bg = code_bg } },
				{ "@text.literal.markdown_inline", { fg = code_fg, bg = code_bg } },
				{ "@text.literal.block", { fg = code_fg, bg = code_bg } },
				{ "markdownBlockquote", { fg = quote_fg, bg = quote_bg, italic = true } },
				{ "@text.quote.markdown", { fg = quote_fg, bg = quote_bg, italic = true } },
				{ "@text.quote", { fg = quote_fg, bg = quote_bg, italic = true } },
			}

			for _, spec in ipairs(markdown_accents) do
				vim.api.nvim_set_hl(0, spec[1], spec[2])
			end
		end,
		},
	}
