-- https://github.com/mfussenegger/nvim-lint
require('lint').linters_by_ft = {
  dockerfile = {'hadolint'},
  -- enable all: python = {'mypy', 'pylint', 'ruff', 'flake8'},
  json = {'jsonlint'},
  markdown = {'markdownlint'},
  python = {'flake8'},
  sh = {'shellcheck'},
  tex = {'chktex'},
  yaml = {'yamllint'},
}

vim.api.nvim_create_autocmd({'BufWritePost'}, {
  callback = function()
    require('lint').try_lint()
  end,
})
