local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local options = {
  "NOTE",
  "TIP",
  "IMPORTANT",
  "WARNING",
  "CAUTION",
  "code",
  "details",
}

local function apply_markdown_tip(selection_type, start_line, end_line)
  -- Ensure start is before end and valid
  if not start_line or not end_line or start_line == 0 or end_line == 0 then
      vim.notify("No selection found", vim.log.levels.WARN)
      return
  end
  -- Just in case
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local buf = vim.api.nvim_get_current_buf()
  -- get_lines uses 0-based indexing, end-exclusive
  -- start_line is 1-based. So start_line-1.
  -- end_line is 1-based. To include it, we use end_line.
  local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)

  local new_lines = {}

  if selection_type == "code" then
    table.insert(new_lines, "```")
    for _, line in ipairs(lines) do
      table.insert(new_lines, line)
    end
    table.insert(new_lines, "```")

  elseif selection_type == "details" then
    table.insert(new_lines, "<details>")
    table.insert(new_lines, "<summary>クリックして表示</summary>")
    for _, line in ipairs(lines) do
      table.insert(new_lines, line)
    end
    table.insert(new_lines, "</details>")

  else -- NOTE, TIP, IMPORTANT, WARNING, CAUTION
    table.insert(new_lines, "> [!" .. selection_type .. "]")
    for _, line in ipairs(lines) do
      table.insert(new_lines, "> " .. line)
    end
  end

  -- Replace the lines
  vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, new_lines)
end

function M.picker()
  local start_line, end_line
  local mode = vim.fn.mode()
  
  -- Check if we are in any visual mode (v, V, or CTRL-V)
  -- CTRL-V is represented as \22 in Lua string
  if mode == 'v' or mode == 'V' or mode == '\22' then
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")
    start_line = start_pos[2]
    end_line = end_pos[2]
    
    -- Exit visual mode to allow Telescope to open cleanly and to prevent
    -- accidental operations on the selection later.
    -- However, Telescope usually handles mode switching.
    -- The important part is we captured the lines.
  else
    -- Fallback: use the last visual selection marks
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    start_line = start_pos[2]
    end_line = end_pos[2]
  end

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  pickers.new({}, {
    prompt_title = "Markdown Tips & Alerts",
    finder = finders.new_table {
      results = options,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection then
          apply_markdown_tip(selection[1], start_line, end_line)
        end
      end)
      return true
    end,
  }):find()
end

return M