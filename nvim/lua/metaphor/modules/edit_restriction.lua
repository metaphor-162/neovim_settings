local M = {}

function M.setup()
	local group = vim.api.nvim_create_augroup("EditRestriction", { clear = true })
	local zettelkasten_home = os.getenv("ZETTELKASTEN_HOME") or (os.getenv("HOME") .. "/dotfiles/zettelkasten")

	-- Helper function to check date
	local function is_past_note(bufnr)
		local filepath = vim.api.nvim_buf_get_name(bufnr)
		if not zettelkasten_home or not filepath:find(zettelkasten_home, 1, true) then
			return false
		end

		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)
		local created_at = nil
		local has_mutable_tag = false

		for i, line in ipairs(lines) do
			-- Check for mutable tag
			-- Consider lines starting with 'tags:' or list items '-'
			if line:match("^tags%s*:") or line:match("^%s*-%s*") then
				-- Use padded matching for whole word 'mutable' to avoid Lua pattern issues with %f in some versions
				local padded = " " .. line .. " "
				if padded:match("%Wmutable%W") then
					has_mutable_tag = true
				end
			end

			local match = line:match("^createdAt:%s*(.*)")
			if match then
				created_at = match
			end

			if line == "---" and i > 1 then
				break
			end
		end

		if has_mutable_tag then
			return false
		end

		if created_at then
			-- UTC+9 (JST) で判定
			local current_date = os.date("!%Y-%m-%d", os.time() + 9 * 3600)
			local note_date = created_at:match("(%d+-%d+-%d+)")

			if note_date and note_date ~= current_date then
				return true
			end
		end
		return false
	end

	-- ファイルを開いたときに編集不可にする
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
		group = group,
		pattern = "*.md",
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			if is_past_note(bufnr) then
				vim.bo[bufnr].modifiable = false
				-- vim.bo[bufnr].readonly = true -- readonlyをつけると :w! でも保存できなくなる 場合があるのでmodifiableのみで制御推奨だが、ユーザー体験的にはreadonlyが良いか。
				-- readonly = true でも :w! なら保存できる（Vimの仕様）。
				vim.bo[bufnr].readonly = true
			end
		end,
	})

	-- 保存時にブロックする（念の為）
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = group,
		pattern = "*.md",
		callback = function()
			-- 強制保存 (:w!) は許可
			if vim.v.cmdbang == 1 then
				-- 保存前に一時的にmodifiableに戻す必要があるかもしれないが、
				-- :w! で readonly ファイルを保存しようとすると、Vimは通常上書きを試みる。
				-- ただし modifiable = false だとバッファの変更自体ができないので、ここに来る前 に編集できないはず。
				-- ここに来るのは「:set modifiable」などで無理やり編集した後や、
				-- modifiable制御が効かなかった場合。
				return
			end

			local bufnr = vim.api.nvim_get_current_buf()
			if is_past_note(bufnr) then
				vim.notify(
					"⚠️  過去のノートです。編集・保存は制限されています。\n変更するには :w!  を使用してください（フロントマターは自動更新されます）。",
					vim.log.levels.WARN
				)
				-- 保存を中止させるためにエラーを投げる
				error("Edit restriction: Past notes cannot be saved without '!'")
			end
		end,
	})
end

return M
