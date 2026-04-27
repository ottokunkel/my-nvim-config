return {
  'stevearc/oil.nvim',
  lazy = false,
  keys = {
    { '<leader>-', '<cmd>Oil<cr>', desc = 'Oil (parent dir)' },
    {
      '<leader>_',
      function() require('oil').open(vim.fn.getcwd()) end,
      desc = 'Oil (cwd)',
    },
  },
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = false,
    },
    use_default_keymaps = true,
    keymaps = {
      ['q'] = 'actions.close',
      -- free up tmux-navigator bindings (oil binds <C-h>=split, <C-l>=refresh by default)
      ['<C-h>'] = false,
      ['<C-j>'] = false,
      ['<C-k>'] = false,
      ['<C-l>'] = false,
      -- restore oil's refresh on a different key
      ['<C-r>'] = 'actions.refresh',
      -- horizontal split via oil keeps existing <C-s> for vsplit
      ['<C-x>'] = 'actions.select_split',
      -- :cd nvim into the directory shown in the oil buffer
      ['cd'] = { 'actions.cd', mode = 'n', desc = ':cd to current oil dir' },
    },
    float = {
      padding = 4,
      border = 'rounded',
      win_options = {
        winblend = 10,
      },
    },
  },
}
