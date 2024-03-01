local empty_module = {
  picker = function()
    vim.notify("Missing dependencies: telescope", vim.log.levels.ERROR)
  end,
  save_history = function()
  end,
  reset_history = function()
  end,
}
-- pcall all dependencies from telescope to avoid errors when telescope is not installed
local ok, _ = pcall(require, "telescope")
if not ok then
  return empty_module
end
local pickers_ok, _ = pcall(require, "telescope.pickers")
if not pickers_ok then
  return empty_module
end
local finders_ok, _ = pcall(require, "telescope.finders")
if not finders_ok then
  return empty_module
end
local config_ok, _ = pcall(require, "telescope.config")
if not config_ok then
  return empty_module
end
local actions_ok, _ = pcall(require, "telescope.actions")
if not actions_ok then
  return empty_module
end
local state_ok, _ = pcall(require, "telescope.actions.state")
if not state_ok then
  return empty_module
end
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local M = {}

local reverse = function(tbl)
  local reversed = {}
  for i = #tbl, 1, -1 do
    table.insert(reversed, tbl[i])
  end
  return reversed
end

local format = function(tbl, new)
  if tbl == nil then
    return {}
  end
  local formatted = {}
  for _, theme in ipairs(tbl) do
    if theme ~= new then
      table.insert(formatted, theme)
    end
  end
  return formatted
end

local get_history_path = function()
  local src = debug.getinfo(2, "S").source
  if src:sub(1, 1) == "@" then
    return src:sub(2, (#src - #"history.lua"))
  end
  return nil
end

local get_history = function()
  local path = get_history_path()
  local file = io.open(path .. "history.json", "r")
  if not file then
    return
  end
  local history_json = file:read("*a")
  if history_json == "" then
    file:close()
    history_json = '{"history": []}'
  end
  local history = vim.fn.json_decode(history_json)["history"]
  if not history then
    file:close()
    return {}
  end
  file:close()
  return reverse(history)
end

M.picker = function(opts)
  if not pickers then
    return
  end
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Theme History",
    finder = finders.new_table {
      results = get_history(),
    },
    sorter = config.values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd.colorscheme(selection[1])
      end)
      return true
    end
  }):find()
end

M.save_history = function(new_theme)
  local history = format(get_history(), new_theme)
  local stringify_history = function()
    local new_history = "["
    if history then
      for _, theme in ipairs(history) do
        new_history = new_history .. '"' .. theme .. '",'
      end
    else
      return '{"history": ["' .. new_theme .. '"]}'
    end
    new_history = new_history .. '"' .. new_theme .. '"]'
    return '{"history": ' .. new_history .. '}'
  end

  local path = get_history_path()
  local file = io.open(path .. "history.json", "w+")
  if not file then
    return
  end
  local history_json = stringify_history()
  file.write(file, history_json)
  file:close()
end

M.reset_history = function()
  local path = get_history_path()
  local file = io.open(path .. "history.json", "w+")
  if not file then
    return
  end
  file:write('{"history": []}')
  file:close()
end

return M
