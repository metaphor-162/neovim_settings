local M = {}
function M.yank_todays_obsidian_notes(vault_dir)
	return function()
		-- ホームディレクトリを取得
		local home_dir = os.getenv("HOME")
		local full_vault_dir = vault_dir:gsub("^~", home_dir)
		-- パスの末尾にスラッシュがない場合に追加
		if not full_vault_dir:match("/$") then
			full_vault_dir = full_vault_dir .. "/"
		end
		-- コマンドを構築
		local command = string.format(
			'find %s -type f -name \'*.md\' -newermt "$(date +%%Y-%%m-%%d)" ! -newermt "$(date -v +1d +%%Y-%%m-%%d)"',
			full_vault_dir
		)

		-- コマンドを実行してファイルリストを取得
		local handle = io.popen(command)
		local result = handle:read("*a")
		handle:close()

		-- ファイルリストを行ごとに分割
		local files = {}
		for line in result:gmatch("[^\r\n]+") do
			table.insert(files, line)
		end

		if #files == 0 then
			vim.notify("今日作成または編集されたノートはありません。", vim.log.levels.INFO)
			return
		end

		-- マークダウンリンクを作成
		local markdown_links = {}
		for _, file in ipairs(files) do
			local filename = vim.fn.fnamemodify(file, ":t:r")
			table.insert(markdown_links, string.format("[[%s]]", filename))
		end

		-- クリップボードにコピー
		local yank_content = table.concat(markdown_links, "\n")
		vim.fn.setreg('"', yank_content)
		vim.fn.setreg("+", yank_content)
		vim.notify(string.format("%d個のノートリンクをヤンクしました。", #files), vim.log.levels.INFO)
	end
end
return M
