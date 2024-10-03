local M = {}
local opts = {
  default_theme = "default",
  auto_persist = true,
  override_groups = {},
  theme_overrides = {},
  auto_override = false,
}
local save_history = nil
M.picker = nil
local history = require("goethe.history")
M.picker = history.picker
M.reset_history = history.reset_history or nil
save_history = history.save_history or nil

local get_script_path = function()
  local src = debug.getinfo(2, "S").source
  if src:sub(1, 1) == "@" then
    return src:sub(2, (#src - #"init.lua"))
  end
  return nil
end

local function update_hl(group, tbl)
  local old_hl = vim.api.nvim_get_hl_by_name(group, true)
  local new_hl = vim.tbl_extend("force", old_hl, tbl)
  vim.api.nvim_set_hl(0, group, new_hl)
end

local override_theme = function(theme)
  for _, group in pairs(opts.theme_overrides) do
    if theme == group.theme then
      if not group.variant then
        return theme
      end
      return group.variant
    end
  end
  return theme
end

local get_theme = function()
  local path = get_script_path()
  local file = io.open(path .. "theme.json", "r")
  if not file then
    return opts.default_theme
  end
  local theme_json = file:read("*a")
  local theme = vim.fn.json_decode(theme_json)["theme"]
  if not theme then
    return override_theme(opts.default_theme)
  end
  if theme == "" then
    return override_theme(opts.default_theme)
  else
    return override_theme(theme)
  end
end

local function update_groups()
  for _, group in ipairs(opts.override_groups) do
    update_hl(group.group, group.tbl)
  end
end

local auto_persist = function()
  if opts.auto_persist == true then
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local path = get_script_path()
        local file = io.open(path .. "theme.json", "w+")
        if not file then
          return
        end
        local theme = vim.g.colors_name
        local theme_json = '{ "theme": "' .. theme .. '" }'
        file:write(theme_json)
        update_groups()
        if save_history then
          save_history(theme)
        end
      end,
    })
  end
end

local auto_override = function(theme)
  if opts.auto_override then
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        override_theme(theme)
      end,
    })
  end
end

M.persist = function()
  local path = get_script_path()
  local file = io.open(path .. "theme.json", "w+")
  if not file then
    return
  end
  local theme = vim.g.colors_name
  local theme_json = '{ "theme": "' .. theme .. '" }'
  file:write(theme_json)
  if save_history then
    save_history(theme)
  end
end

M.setup = function(user_opts)
  local theme = get_theme()
  for key in pairs(opts) do
    if user_opts[key] then
      opts[key] = user_opts[key]
    end
  end
  vim.cmd.colorscheme(theme)
  auto_persist()
  update_groups()
  auto_override(theme)
end

M.reset = function()
  local path = get_script_path()
  local file = io.open(path .. "theme.json", "w+")
  if not file then
    return
  end
  local theme = opts.default_theme
  local theme_json = '{ "theme": "' .. theme .. '" }'
  file:write(theme_json)
  if save_history then
    save_history(theme)
  end
  file:close()
  M.setup(opts)
end

return M
