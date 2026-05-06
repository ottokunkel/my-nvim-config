return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
        return 'make install_jsregexp'
      end)(),
      dependencies = { 'rafamadriz/friendly-snippets' },
      opts = {
        enable_autosnippets = true,
        store_selection_keys = '<Tab>',
      },
      config = function(_, opts)
        local luasnip = require('luasnip')
        local ft_functions = require('luasnip.extras.filetype_functions')

        opts.load_ft_func = ft_functions.extend_load_ft({
          markdown = { 'html' },
        })
        luasnip.setup(opts)
        luasnip.filetype_extend('markdown', { 'html' })
        require('luasnip.loaders.from_lua').lazy_load({
          paths = { vim.fn.stdpath('config') .. '/lua/snippets' },
        })
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
      per_filetype = {
        markdown = { 'lsp', 'path', 'snippets', 'buffer' },
        text = { 'path', 'snippets', 'buffer' },
        gitcommit = { 'path', 'snippets', 'buffer' },
      },
    },

    snippets = { preset = 'luasnip' },

    fuzzy = { implementation = 'lua' },

    signature = { enabled = true },
  },
}
