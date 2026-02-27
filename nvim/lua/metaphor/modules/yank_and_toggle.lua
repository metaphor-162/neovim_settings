-- yank_and_toggle.lua
local M = {}

-- ヤンクしてwindowを表示
-- 引数: toggle_command - windowを表示するコマンド
function M.yank_and_toggle(toggle_command)
	return function()
		-- バッファのファイル名とコード全文をヤンク
		local bufnr = vim.api.nvim_get_current_buf()
		local filename = vim.api.nvim_buf_get_name(bufnr)
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		local content = table.concat(lines, "\n")
		local filetype = filename:match("^.+(%..+)$")
		local yanked_content = filename
			.. "\n```"
			.. filetype
			.. "\n" -- ファイルタイプを追加
			.. content
			.. "\n```\n\nコードとファイル名を共有します！コードを分析し、100文字で日本語で解説して"
		vim.fn.setreg("*", yanked_content)

		vim.cmd(toggle_command)
		-- ヤンクした内容をレジスタに保存
	end
end

-- telekastenのyank_notelinkが使えなかったので対応
function M.yank_link()
	return function()
		-- バッファのファイル名とコード全文をヤンク
		local bufnr = vim.api.nvim_get_current_buf()
		local filename = vim.api.nvim_buf_get_name(bufnr)
		local yanked_content = "[[" .. filename .. "]]"
		vim.fn.setreg("*", yanked_content)
		vim.notify("yanked" .. yanked_content)
	end
end

return M
