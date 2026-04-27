return {
  'nvim-telescope/telescope.nvim',
  enabled = true,
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function() return vim.fn.executable 'make' == 1 end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'

    -- Core search (fast, direct)
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Grep Files' })
    vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = 'Word Under Cursor' })
    vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = 'Recent Files' })
    vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, { desc = 'Symbols (Document)' })
    vim.keymap.set('n', '<leader>sS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Symbols (Workspace)' })

    -- Telescope itself (escape hatch for any picker)
    vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = 'Telescope Pickers' })

    -- Less frequent
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help Tags' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = 'Commands' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
    vim.keymap.set('n', '<leader>sR', builtin.resume, { desc = 'Resume Last Search' })

    -- Quick access (no s prefix)
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Switch Buffer' })

    -- LSP navigation (kept on gr* convention; not duplicated under <leader>s)
    vim.keymap.set('n', 'grr', builtin.lsp_references, { desc = 'Goto References' })
    vim.keymap.set('n', 'gri', builtin.lsp_implementations, { desc = 'Goto Implementation' })
    vim.keymap.set('n', 'grd', builtin.lsp_definitions, { desc = 'Goto Definition' })
    vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { desc = 'Goto Type Definition' })
    vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { desc = 'Document Symbols' })
    vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { desc = 'Workspace Symbols' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = 'Search in Current Buffer' })

    vim.keymap.set(
      'n',
      '<leader>s/',
      function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end,
      { desc = 'Grep Open Files' }
    )

    vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = 'Find Neovim Config Files' })
  end,
}
