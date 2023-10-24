---@type ChadrcConfig
local M = {}

M.ui = {
  theme = 'catppuccin',
  theme_toggle = { 'catppuccin', 'gruvbox_light' },

  statusline = { theme = 'vscode_colored' },

  tabufline = {enabled = false},

  -- hl_override = {
  --   Comment = { italic = true },
  --   SpecialComment = { italic = true },
  --   TSKeyword = { bold = true, italic = true },
  --   Keyword = { bold = true, italic = true },
  --   TSAttribute = { bold = true, italic = true },
  --   TSParameter = { bold = true, italic = true },
  --   TSLabel = { bold = true, italic = true },
  --   TSVariableBuiltin = { bold = true, italic = true },
  --   TSTagAttribute = { bold = true, italic = true },
  -- },
  hl_add = { NvimTreeOpenedFolderName = { fg = 'green', bold = true } },
}

M.plugins = 'custom.plugins'

-- check core.mappings for table structure
M.mappings = require 'custom.mappings'

return M
