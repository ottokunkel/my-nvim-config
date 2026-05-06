return {
  name = 'dracula-plus-local',
  dir = vim.fn.stdpath('config'),
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme('dracula-plus')
  end,
}
