return {
  'stevearc/oil.nvim',
  lazy = false,
  keys = {
    { '<leader>-', '<cmd>Oil<cr>', desc = 'Oil (parent dir)' },
    { '<leader>e', '<cmd>Oil<cr>', desc = 'Open File Explorer' },
    {
      '<leader>_',
      function() require('oil').open(vim.fn.getcwd()) end,
      desc = 'Oil (cwd)',
    },
    {
      '<leader>E',
      function() require('oil').open(vim.fn.getcwd()) end,
      desc = 'Open File Explorer (cwd)',
    },
  },
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    constrain_cursor = false,
    view_options = {
      show_hidden = false,
      is_hidden_file = function (name)
        local hidden_dirs = {
          [".git"] = true,
          ["node_modules"] = true,
          [".egg-info"] = true,
          ["__pycache__"] = true,
        }

        return vim.startswith(name, ".")
          or hidden_dirs[name] == true
          or name:match("%.egg%-info$") ~= nil
      end,

      sort = {
        { 'type', 'asc' },
        { 'extension', 'asc' },
        { 'name', 'asc' },
      },
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
  config = function(_, opts)
    local FIELD_NAME = require('oil.constants').FIELD_NAME
    require('oil.columns').register('extension', {
      render = function() error('extension column is for sorting only') end,
      parse = function() error('extension column is for sorting only') end,
      get_sort_value = function(entry)
        local name = entry[FIELD_NAME]
        return name:match('%.([^.]+)$') or ''
      end,
    })
    require('oil').setup(opts)
  end,
}
