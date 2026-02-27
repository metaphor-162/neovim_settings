local M = {}

-- telekastenのyank_notelinkが使えなかったので対応
function M.create_daily_note(vault_dir)
	return function()
		-- yyyymmdd形式の日付を取得
		local current_time = os.time()
		local date = os.date("%Y%m%d", current_time)
		local yesterday = os.date("%Y%m%d", current_time - 86400)
		local tomorrow = os.date("%Y%m%d", current_time + 86400)

		-- 年/月/日 のディレクトリ構造用
		local year = os.date("%Y", current_time)
		local month = os.date("%m", current_time)
		local day = os.date("%d", current_time)

		-- 出力先パス: zettelkasten/dagnetz/yyyy/mm/dd/📓yyyymmdd_dashboard.md
		-- vault_dir は .../zettelkasten を想定
		local dir_path = string.format("%s/dagnetz/%s/%s/%s", vault_dir, year, month, day)
		local file_name = string.format("📓%s_dashboard.md", date)
		local full_path = dir_path .. "/" .. file_name

		-- ディレクトリ作成 (存在しない場合)
		if vim.fn.isdirectory(dir_path) == 0 then
			vim.fn.mkdir(dir_path, "p")
		end

		-- ファイルの存在を確認する関数
		local function file_exists(path)
			local f = io.open(path, "r")
			if f then
				f:close()
				return true
			end
			return false
		end

		if file_exists(full_path) then
			-- ファイルが既に存在する場合は、そのファイルを開く
			vim.cmd("edit " .. vim.fn.fnameescape(full_path))
		else
			-- ファイルが存在しない場合は新規作成
			-- テンプレート内に "]]" が含まれるため、[=[ ... ]=] で囲む
			local template = string.format(
				[=[
[[📓%s_dashboard]] | [[📓%s_dashboard]]

## 看板 (並列作業で迷走しないために)

## メモ

]=],
				yesterday,
				tomorrow
			)

			local file = io.open(full_path, "w")
			if file then
				file:write(template)
				file:close()
				vim.cmd("edit " .. vim.fn.fnameescape(full_path))
			else
				print("Failed to create daily note at " .. full_path)
			end
		end
	end
end
return M
