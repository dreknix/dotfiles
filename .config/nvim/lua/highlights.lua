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
    bold = true,
  },
}

M.add = {
}

return M
