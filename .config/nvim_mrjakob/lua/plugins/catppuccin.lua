-- https://github.com/catppuccin/nvim
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function ()
    require("catppuccin").setup({
      flavor = "mocha"
    })
    vim.cmd.colorscheme "catppuccin"
  end,
}
