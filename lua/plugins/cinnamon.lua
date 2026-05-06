return {
  'declancm/cinnamon.nvim',
  version = '*',
  event = 'VeryLazy',
  opts = {
    keymaps = {
      basic = true,
      extra = false,
    },
    options = {
      mode = 'window',
      delay = 1,
      max_delta = {
        line = false,
        column = false,
        time = 110,
      },
      step_size = {
        vertical = 2,
        horizontal = 4,
      },
    },
  },
  config = function(_, opts)
    local cinnamon = require 'cinnamon'
    cinnamon.setup(opts)

    local map = vim.keymap.set
    local function scroll(cmd)
      return function()
        cinnamon.scroll(cmd)
      end
    end

    map('n', 'gg', function()
      cinnamon.scroll(vim.v.count > 0 and (vim.v.count .. 'gg') or 'gg')
    end, { desc = 'Top of file' })
    map('n', 'G', function()
      cinnamon.scroll(vim.v.count > 0 and (vim.v.count .. 'G') or 'G')
    end, { desc = 'Bottom of file' })

    map('n', '<C-d>', scroll '<C-d>zz', { desc = 'Half page down' })
    map('n', '<C-u>', scroll '<C-u>zz', { desc = 'Half page up' })
    map('n', 'n', scroll 'nzzzv', { desc = 'Next search result' })
    map('n', 'N', scroll 'Nzzzv', { desc = 'Prev search result' })
    map('n', 'zz', scroll 'zz', { desc = 'Center cursor line' })
    map('n', 'zt', scroll 'zt', { desc = 'Cursor line to top' })
    map('n', 'zb', scroll 'zb', { desc = 'Cursor line to bottom' })
    map('n', '<C-y>', scroll '<C-y>', { desc = 'Scroll window up' })
    map('n', '<C-e>', scroll '<C-e>', { desc = 'Scroll window down' })
  end,
}
