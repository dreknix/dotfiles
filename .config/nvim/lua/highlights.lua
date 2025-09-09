-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors
--
-- Use "<cmd> Inspect" to get the highlight group under the cursor.
-- "<cmd> hi Comment" show the configuration of the hightlight group 'Comment'

local M = {}

M.override = {
  Comment = {
    italic = true,
    -- bold = true,
    -- fg = "#7c7f93",  -- overlay2
    -- fg = "#8c8fa1",  -- overlay1
    fg = "#9ca0b0",  -- overlay0
  },
  ["@comment"] = { link = "Comment" },
}

M.add = {
}

return M
