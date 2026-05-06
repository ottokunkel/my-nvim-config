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
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
          '--glob',
          '!.git/*',
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/*' },
        },
      },
      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'
    local map = vim.keymap.set

    -- Top-level (LazyVim-style)
    map('n', '<leader><leader>', builtin.find_files, { desc = 'Find Files' })
    map('n', '<leader>/', builtin.live_grep, { desc = 'Grep (Root Dir)' })
    map('n', '<leader>:', builtin.command_history, { desc = 'Command History' })

    -- Find / files (<leader>f)
    map('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
    map('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent Files' })
    map('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
    map('n', '<leader>fc', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = 'Find Config File' })
    map('n', '<leader>fg', builtin.git_files, { desc = 'Find Files (git-files)' })

    -- Search (<leader>s)
    map('n', '<leader>sg', builtin.live_grep, { desc = 'Grep (Root Dir)' })
    map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = 'Word Under Cursor' })
    map('n', '<leader>sb', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = 'Buffer Lines' })
    map('n', '<leader>sB', function()
      builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
    end, { desc = 'Grep Open Buffers' })

    -- Symbols — easy access from multiple paths
    local code_symbol_kinds = {
      'class',
      'constructor',
      'function',
      'interface',
      'method',
      'struct',
      'trait',
    }

    map('n', '<leader>sf', function()
      builtin.treesitter {
        prompt_title = 'Functions / Classes',
        symbols = code_symbol_kinds,
      }
    end, { desc = 'Functions / Classes' })
    map('n', '<leader>sT', builtin.treesitter, { desc = 'Treesitter Symbols' })
    map('n', '<leader>ss', builtin.lsp_document_symbols, { desc = 'Goto Symbol' })
    map('n', '<leader>sS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Goto Symbol (Workspace)' })

    -- Misc pickers
    map('n', '<leader>sh', builtin.help_tags, { desc = 'Help Pages' })
    map('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
    map('n', '<leader>sc', builtin.commands, { desc = 'Commands' })
    map('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
    map('n', '<leader>sR', builtin.resume, { desc = 'Resume' })
    map('n', '<leader>sj', builtin.jumplist, { desc = 'Jumplist' })
    map('n', '<leader>sm', builtin.marks, { desc = 'Marks' })
    map('n', '<leader>sq', builtin.quickfix, { desc = 'Quickfix List' })
    map('n', '<leader>s"', builtin.registers, { desc = 'Registers' })
    map('n', '<leader>st', builtin.builtin, { desc = 'Telescope Pickers' })

    -- LSP navigation (kept on gr* convention)
    map('n', 'grr', builtin.lsp_references, { desc = 'Goto References' })
    map('n', 'gri', builtin.lsp_implementations, { desc = 'Goto Implementation' })
    map('n', 'grd', builtin.lsp_definitions, { desc = 'Goto Definition' })
    map('n', 'grt', builtin.lsp_type_definitions, { desc = 'Goto Type Definition' })
    map('n', 'gO', builtin.lsp_document_symbols, { desc = 'Document Symbols' })
    map('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { desc = 'Workspace Symbols' })
  end,
}
