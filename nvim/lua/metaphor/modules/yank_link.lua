-- yank_link.lua
local M = {}
-- telekastenのyank_notelinkが使えなかったので対応
function M.yank_link()
	return function()
		-- バッファのファイル名とコード全文をヤンク
		local bufnr = vim.api.nvim_get_current_buf()
		local filename = vim.api.nvim_buf_get_name(bufnr)

		-- ファイルパスからファイル名を抽出
		local file_basename = filename:match("^.+/(.+)$")
		-- 拡張子を取り除く
		local file_title = file_basename:match("(.+)%..+$")

		local yanked_content = "[[" .. file_title .. "]]"
		vim.fn.setreg("*", yanked_content)
		vim.notify("yanked " .. yanked_content)
	end
end
return M
