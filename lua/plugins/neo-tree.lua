return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Neotree',
  keys = {
    {
      '<leader>e',
      function()
        -- Plain toggle at cwd — never reveal, so oil:// and other non-file
        -- buffers don't trigger the "change cwd?" prompt.
        vim.cmd('Neotree toggle dir=' .. vim.fn.getcwd())
      end,
      desc = 'Neo-tree toggle (cwd)',
    },
    {
      '<leader>E',
      function()
        -- Reveal only works for real files on disk; fall back to plain toggle
        -- when the current buffer is oil://, neo-tree, terminal, etc.
        local name = vim.api.nvim_buf_get_name(0)
        local is_real_file = name ~= '' and not name:match('^%w+://') and vim.fn.filereadable(name) == 1
        if is_real_file then
          vim.cmd('Neotree reveal')
        else
          vim.cmd('Neotree toggle dir=' .. vim.fn.getcwd())
        end
      end,
      desc = 'Neo-tree reveal file',
    },
    { '<leader>ge', '<cmd>Neotree git_status toggle<cr>',    desc = 'Neo-tree git status' },
    { '<leader>be', '<cmd>Neotree buffers toggle<cr>',       desc = 'Neo-tree buffers' },
  },
  opts = {
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
      icon = {
        folder_closed = vim.g.have_nerd_font and '' or '▸',
        folder_open   = vim.g.have_nerd_font and '' or '▾',
        folder_empty  = vim.g.have_nerd_font and '' or '▿',
        default       = vim.g.have_nerd_font and '' or ' ',
      },
      modified = { symbol = '●' },
      git_status = {
        symbols = {
          added     = '+',
          modified  = '~',
          deleted   = '✖',
          renamed   = '➜',
          untracked = '?',
          ignored   = '◌',
          unstaged  = '✗',
          staged    = '✓',
          conflict  = '!',
        },
      },
    },
    window = {
      width = 32,
      mappings = {
        ['<space>'] = 'none',
        ['l'] = 'open',
        ['h'] = 'close_node',
      },
    },
    filesystem = {
      -- follow_current_file would auto-reveal the current buffer in the tree
      -- on every focus change. That triggers the "change cwd?" prompt for
      -- oil:// and other URI-scheme buffers, so we keep it off.
      follow_current_file = { enabled = false },
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = true,
        hide_gitignored = true,
      },
    },
  },
}
