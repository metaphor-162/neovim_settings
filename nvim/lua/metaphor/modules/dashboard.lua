local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

-- --- Helper Actions ---

local function open_file(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    if selection and selection.path then
        vim.cmd("edit " .. vim.fn.fnameescape(selection.path))
    end
end

-- --- Features ---

-- 1. Ranking
function M.open_ranking()
    local cwd = vim.fn.getcwd()
    -- ripgrep to find 'count: N' lines
    -- Output format: path/to/file.md:count: 10
    local cmd = string.format("rg '^count:\\s*(\\d+)' '%s' --with-filename --no-heading --color never", cwd)
    local output = vim.fn.systemlist(cmd)

    if vim.v.shell_error ~= 0 and #output == 0 then
        print("No files with 'count' found.")
        return
    end

    local notes = {}
    for _, line in ipairs(output) do
        local path, count_str = line:match("^(.*):count:%s*(%d+)")
        if path and count_str then
             -- Extract filename for display
            local name = vim.fn.fnamemodify(path, ":t")
            table.insert(notes, { path = path, name = name, count = tonumber(count_str) })
        end
    end

    -- Sort by count desc
    table.sort(notes, function(a, b) return a.count > b.count end)

    -- Add rank index
    local limit = math.min(100, #notes)
    local top_notes = {}
    for i = 1, limit do
        notes[i].rank = i
        table.insert(top_notes, notes[i])
    end

    pickers.new({}, {
        prompt_title = "Ranking (Top 100)",
        finder = finders.new_table {
            results = top_notes,
            entry_maker = function(entry)
                return {
                    value = entry,
                    -- Display: "Rank N [Count] Filename"
                    display = string.format("% -4d [%d] %s", entry.rank, entry.count, entry.name),
                    ordinal = entry.name, -- Filter by filename
                    path = entry.path,
                }
            end,
        },
        sorter = conf.generic_sorter({}),
        previewer = conf.file_previewer({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(open_file)
            return true
        end,
    }):find()
end

-- 2. Todo List
function M.open_todos()
    local cwd = vim.fn.getcwd()
    -- Find files with 'todo' in tags
    -- Using `rg -l` to list files.
    local cmd = string.format("rg -l 'tags:.*todo|\\- todo' '%s' --ignore-case", cwd) 
    local output = vim.fn.systemlist(cmd)

    if #output == 0 then
        print("No todo notes found.")
        return
    end

    local valid_notes = {}

    for _, path in ipairs(output) do
        -- Check if file has 'done' tag (exclude completed tasks)
        local check_done_cmd = string.format("grep -qE 'tags:.*\\[.*done.*\\]|tags:.*done|\\- done' '%s'", path)
        vim.fn.system(check_done_cmd)
        local is_done = (vim.v.shell_error == 0)

        if not is_done then
            local name = vim.fn.fnamemodify(path, ":t")
            
            -- Filter: Only allow names starting with ✅ or 🚨
            if name:find("^✅") or name:find("^🚨") then
                table.insert(valid_notes, {
                    name = name,
                    path = path
                })
            end
        end
    end

    pickers.new({}, {
        prompt_title = "Todo Notes",
        finder = finders.new_table {
            results = valid_notes,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name,
                    path = entry.path,
                }
            end,
        },
        sorter = conf.generic_sorter({}),
        previewer = conf.file_previewer({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(open_file)
            return true
        end,
    }):find()
end

-- 3. Prefix Grouping
local function open_prefix_files(prefix, files)
    pickers.new({}, {
        prompt_title = "Files: " .. prefix,
        finder = finders.new_table {
            results = files,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name,
                    path = entry.path,
                }
            end,
        },
        sorter = conf.generic_sorter({}),
        previewer = conf.file_previewer({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(open_file)
            return true
        end,
    }):find()
end

function M.open_prefixes()
    local cwd = vim.fn.getcwd()
    -- Find all markdown files
    local cmd = string.format("find '%s' -name '*.md'", cwd)
    local output = vim.fn.systemlist(cmd)

    local groups = {}
    local prefixes = {}

    -- Allowlist for prefixes
    local allowed_prefixes = {
        ["✅"] = true,
        ["⚙"] = true,
        ["⚙️"] = true,
        ["🐾"] = true,
        ["📓"] = true,
        ["📗"] = true,
        ["📘"] = true,
        ["📙"] = true,
        ["📝"] = true,
        ["🚨"] = true,
    }

    for _, path in ipairs(output) do
        local name = vim.fn.fnamemodify(path, ":t")
        local first_char = ""
        local first_byte = string.byte(name, 1)
        
        if first_byte then
            if first_byte < 128 then
                -- Skip ASCII characters (standard letters/numbers)
                first_char = ""
            elseif first_byte >= 194 and first_byte <= 223 then
                first_char = string.sub(name, 1, 2)
            elseif first_byte >= 224 and first_byte <= 239 then
                first_char = string.sub(name, 1, 3)
            elseif first_byte >= 240 and first_byte <= 244 then
                first_char = string.sub(name, 1, 4)
            end
        end
        
        -- Filter only if it is in the allowlist
        if first_char ~= "" and allowed_prefixes[first_char] then
            if not groups[first_char] then
                groups[first_char] = {}
                table.insert(prefixes, first_char)
            end
            table.insert(groups[first_char], {name=name, path=path})
        end
    end
    
    table.sort(prefixes)

    pickers.new({}, {
        prompt_title = "Select Prefix",
        finder = finders.new_table {
            results = prefixes,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry,
                    ordinal = entry,
                }
            end,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                local prefix = selection.value
                if prefix and groups[prefix] then
                    open_prefix_files(prefix, groups[prefix])
                end
            end)
            return true
        end,
    }):find()
end

return M