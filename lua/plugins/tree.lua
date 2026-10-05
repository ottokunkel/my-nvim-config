return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = 'Neotree',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'Explorer Neo-tree' },
    { '<leader>E', '<cmd>Neotree toggle dir=.<cr>', desc = 'Explorer Neo-tree (cwd)' },
    { '<C-n>', '<cmd>Neotree toggle<cr>', desc = 'Toggle File Explorer' },
  },
  opts = {
    close_if_last_window = true,
    window = {
      width = 64,
    },
    source_selector = {
      winbar = true,
      sources = {
        { source = 'filesystem' },
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = true,
        hide_by_name = {
          'node_modules',
          'tmp',
          '.git',
          '__pycache__',
        },
        hide_by_pattern = {
          '*_templ.go',
        },
      },
    },
    event_handlers = {
      {
        event = 'vim_buffer_enter',
        handler = function()
          if vim.bo.filetype == 'neo-tree' then
            vim.cmd [[setlocal fillchars=eob:\ ]]
          end
        end,
      },
    },
  },
}
