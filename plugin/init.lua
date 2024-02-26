local M = {}
local vim = require("vim")
M.get_script_path = function()
  local src = debug.getinfo(2, "S").source
  if src:sub(1, 1) == "@" then
    return src:sub(2, (#src - #"init.lua"))
  end
  return nil
end

M.load_theme = function()
  local path = M.get_script_path()
  local file = io.open(path .. "theme.json", "r")
  if file == nil then
    return
  end
  local theme_json = file:read("*a")
  local theme = vim.fn.json_decode(theme_json)["theme"]
  return theme
end
vim.cmd.colorscheme(M.load_theme())

M.autoPersist = function()
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      local path = M.get_script_path()
      local file = io.open(path .. "theme.json", "w+")
      if file == nil then
        return
      end
      local theme = vim.g.colors_name
      local theme_json = '{ "theme": "' .. theme .. '" }'
      file.write(file, theme_json)
    end,
  })
end
M.autoPersist()

M.persist = function()
  local path = M.get_script_path()
  local file = io.open(path .. "theme.json", "w+")
  if file == nil then
    return
  end
  local theme = vim.g.colors_name
  local theme_json = '{ "theme": "' .. theme .. '" }'
  file.write(file, theme_json)
end

return M