local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M.get_all_tags()
	local tags = {}
	-- Expand path to zettelkasten. Using fixed path based on context or env.
	local zk_path = os.getenv("ZETTELKASTEN_HOME") or (os.getenv("HOME") .. "/dotfiles/zettelkasten")

	-- rg command to find tags and context
	-- -A 10: show 10 lines of context after match
	-- --no-heading: print filename on every line
	-- --line-number: print line number
	-- --color never: pure text
	local command = string.format("rg 'tags:' -A 10 --no-heading --line-number --color never '%s'", zk_path)

	-- Use vim.fn.system for better neovim integration than io.popen
	local result = vim.fn.system(command)
	if vim.v.shell_error ~= 0 then
		-- rg returns exit code 1 if no matches found, which is fine.
		-- But if it's something else, we might want to know.
		if result == "" then
			return {}
		end
	end

	local current_file = nil
	local in_tags = false

	for line in result:gmatch("[^\r\n]+") do
		if line == "--" then
			in_tags = false
		else
			-- Try to match "file:line:tags: content"
			-- Note: Lua pattern %d+ matches line number
			local f, l, content = line:match("^(.-):(%d+):tags:%s*(.*)")
			if f then
				current_file = f
				in_tags = true
				-- Remove surrounding brackets if inline list [a, b]
				if content:match("^%[.*%]$") then
					content = content:match("^%[(.*)%]$")
					for t in content:gmatch("[^,]+") do
						tags[vim.trim(t)] = true
					end
					in_tags = false -- Inline usually means done
				elseif content ~= "" then
					-- Single inline tag
					tags[vim.trim(content)] = true
					in_tags = false
				end
			elseif in_tags and current_file then
				-- Check if line matches current file context "file-line-content"
				-- Use plain find to handle special chars in filename
				if line:find(current_file, 1, true) == 1 then
					-- Extract content after file and line info.
					-- The separator is '-' for context lines in rg
					local rest = line:sub(#current_file + 1)
					-- Expected format: -line-content
					local content = rest:match("^%-%d+%- (.*)")
					if content then
						local list_item = content:match("^%s*-%s+(.*)")
						if list_item then
							tags[vim.trim(list_item)] = true
						elseif content:match("^%s*$") then
						-- skip empty lines
						else
							-- Found something else, like "createdAt:", stop parsing tags for this file
							in_tags = false
						end
					else
						-- format mismatch?
						in_tags = false
					end
				else
					in_tags = false
				end
			end
		end
	end

	local tag_list = {}
	for t, _ in pairs(tags) do
		if t ~= "" then
			table.insert(tag_list, t)
		end
	end
	table.sort(tag_list)
	return tag_list
end

local function insert_tag(tag_name)
	if not tag_name or tag_name == "" then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()

	-- Check and save current buffer state
	local was_modifiable = vim.bo[bufnr].modifiable
	local was_readonly = vim.bo[bufnr].readonly

	-- Temporarily enable editing
	if not was_modifiable then
		vim.bo[bufnr].modifiable = true
	end
	if was_readonly then
		vim.bo[bufnr].readonly = false
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local found_tags = false
	local fm_end = -1

	-- Find frontmatter range
	if lines[1] ~= "---" then
		vim.notify("No frontmatter found.", vim.log.levels.WARN)
		-- Restore state before returning
		if not was_modifiable then
			vim.bo[bufnr].modifiable = false
		end
		if was_readonly then
			vim.bo[bufnr].readonly = true
		end
		return
	end

	for i = 2, #lines do
		if lines[i] == "---" then
			fm_end = i
			break
		end
	end

	if fm_end == -1 then
		vim.notify("Frontmatter not closed.", vim.log.levels.WARN)
		-- Restore state before returning
		if not was_modifiable then
			vim.bo[bufnr].modifiable = false
		end
		if was_readonly then
			vim.bo[bufnr].readonly = true
		end
		return
	end

	-- Perform modification
	local modification_success = false

	for i = 2, fm_end - 1 do
		local line = lines[i]
		if line:match("^tags:") then
			found_tags = true
			local content = line:match("^tags:%s*(.*)")
			local clean_content = vim.trim(content)

			-- Case 1: Inline Array [a, b]
			if clean_content:match("^%[.*%]$") then
				local inner = clean_content:match("^%[(.*)%]$")
				local new_line = string.format("tags: [%s, %s]", inner, tag_name)
				vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, { new_line })
				modification_success = true

			-- Case 2: Empty "tags:" -> check next lines for list
			elseif clean_content == "" then
				-- Check if next line is a list item
				local next_line = lines[i + 1]
				if next_line and next_line:match("^%s*-%s+") then
					-- It is a list. Find the end of the list.
					local insert_pos = i + 1
					while insert_pos < fm_end do
						if not lines[insert_pos]:match("^%s*-%s+") then
							break
						end
						insert_pos = insert_pos + 1
					end
					-- Insert before the non-list line
					local indent = lines[i + 1]:match("^(%s*)") or ""
					vim.api.nvim_buf_set_lines(
						bufnr,
						insert_pos - 1,
						insert_pos - 1,
						false,
						{ indent .. "- " .. tag_name }
					)
					modification_success = true
				else
					-- Empty tags, not a list. Make it inline array.
					vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, { "tags: [" .. tag_name .. "]" })
					modification_success = true
				end

			-- Case 3: Inline single value (or comma separated string)
			else
				-- Convert to array format for consistency
				local new_line = string.format("tags: [%s, %s]", clean_content, tag_name)
				vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, { new_line })
				modification_success = true
			end
			break -- Break after finding and updating tags
		end
	end

	if not found_tags then
		-- Insert "tags: [tag_name]" before the end of frontmatter
		vim.api.nvim_buf_set_lines(bufnr, fm_end - 1, fm_end - 1, false, { "tags: [" .. tag_name .. "]" })
		modification_success = true
	end

	-- Restore buffer state
	if not was_modifiable then
		vim.bo[bufnr].modifiable = false
	end
	if was_readonly then
		vim.bo[bufnr].readonly = true
	end

	if modification_success then
		-- Save explicitly if it was restricted, to persist the tag change
		-- Use noautocmd to avoid triggering other hooks if necessary, or standard write
		if not was_modifiable or was_readonly then
			vim.cmd("silent! noautocmd write!")
			vim.notify("Tag added to restricted note.", vim.log.levels.INFO)
		else
			-- Normal save
			vim.cmd("noautocmd write")
		end
	end
end

function M.picker()
	local tags = M.get_all_tags()

	pickers
		.new({}, {
			prompt_title = "Frontmatter Tags",
			finder = finders.new_table({
				results = tags,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					local current_line = action_state.get_current_line()

					actions.close(prompt_bufnr)

					if selection then
						insert_tag(selection[1])
					elseif current_line ~= "" then
						insert_tag(current_line)
					end
				end)
				return true
			end,
		})
		:find()
end

return M
