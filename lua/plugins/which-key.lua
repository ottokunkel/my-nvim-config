return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  ---@module 'which-key'
  ---@type wk.Opts
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    preset = 'helix',
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    win = {
      border = 'rounded',
      padding = { 1, 2 },
    },
    layout = {
      width = { min = 20 },
      spacing = 6,
    },

    spec = {
      { '<leader>f', group = 'File/Find', icon = { icon = ' ', color = 'green' } },
      { '<leader>s', group = 'Search', icon = { icon = ' ', color = 'cyan' }, mode = { 'n', 'v' } },
      { '<leader>w', group = 'Window', icon = { icon = ' ', color = 'blue' } },
      { '<leader>b', group = 'Buffer', icon = { icon = ' ', color = 'green' } },
      { '<leader>t', group = 'Toggle', icon = { icon = ' ', color = 'yellow' } },
      { '<leader>z', group = 'Folds', icon = { icon = ' ', color = 'yellow' } },
      { '<leader>g', group = 'Git', icon = { icon = ' ', color = 'orange' } },
      { '<leader>c', group = 'Code', icon = { icon = ' ', color = 'magenta' } },
      { '<leader>x', group = 'Diagnostics/Quickfix', icon = { icon = ' ', color = 'red' } },
      { '<leader>q', group = 'Quit', icon = { icon = ' ', color = 'red' } },
      { '<leader>h', group = 'Git Hunk', icon = { icon = ' ', color = 'orange' }, mode = { 'n', 'v' } },
      { '<leader><leader>', icon = { icon = ' ', color = 'blue' }, desc = 'Find Files' },
      { '<leader>/', icon = { icon = ' ', color = 'cyan' }, desc = 'Grep' },
      { '<leader>-', icon = { icon = ' ', color = 'yellow' } },
      { '<leader>e', icon = { icon = ' ', color = 'yellow' } },
      { 'gr', group = 'LSP', icon = { icon = ' ', color = 'purple' }, mode = { 'n' } },
    },
  },
}
