local M = {}
local opts = {
  default_theme = "default",
  auto_persist = true,
  override_groups = {},
}

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

local load_theme = function()
  local path = get_script_path()
  local file = io.open(path .. "theme.json", "r")
  if file == nil then
    return
  end
  local theme_json = file:read("*a")
  local theme = vim.fn.json_decode(theme_json)["theme"]
  if theme == nil then
    return opts.default_theme
  end
  return theme
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
        if file == nil then
          return
        end
        local theme = vim.g.colors_name
        local theme_json = '{ "theme": "' .. theme .. '" }'
        file.write(file, theme_json)
        update_groups()
      end,
    })
  end
end

M.persist = function()
  local path = get_script_path()
  local file = io.open(path .. "theme.json", "w+")
  if file == nil then
    return
  end
  local theme = vim.g.colors_name
  local theme_json = '{ "theme": "' .. theme .. '" }'
  file.write(file, theme_json)
end

M.setup = function(user_opts)
  for key in pairs(opts) do
    if user_opts[key] ~= nil then
      opts[key] = user_opts[key]
    end
  end
  vim.cmd.colorscheme(load_theme())
  auto_persist()
  update_groups()
end

return M
