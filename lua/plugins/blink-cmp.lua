return {
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
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
          typescriptreact = { 'html' },
          liquid = { 'html' },
        })
        luasnip.setup(opts)
        luasnip.filetype_extend('markdown', { 'html' })
        luasnip.filetype_extend('typescriptreact', { 'html' })
        luasnip.filetype_extend('liquid', { 'html' })
        require('luasnip.loaders.from_lua').lazy_load({
          paths = { vim.fn.stdpath('config') .. '/lua/snippets' },
        })
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    'Kaiser-Yang/blink-cmp-avante',
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<Tab>'] = false,
      ['<S-Tab>'] = false,
    },

    cmdline = {
      keymap = { preset = 'super-tab' },
      completion = {
        menu = { auto_show = true },
      },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      list = {
        selection = { auto_insert = true },
      },

      documentation = {
        auto_show = true,
        window = { border = 'rounded' },
      },

      menu = {
        border = 'rounded',
        draw = {
          gap = 2,
          components = {
            source_name = {
              text = function(ctx)
                local labels = {
                  LSP = '[LSP]',
                  Snippets = '[SNIP]',
                  Buffer = '[BUF]',
                  Path = '[PATH]',
                  LazyDev = '[LAZY]',
                  Avante = '[AI]',
                }

                return labels[ctx.source_name]
              end,
            },
          },
          columns = {
            { 'source_name', gap = 1 },
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind', gap = 2 },
          },
        },
      },
    },

    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        AvanteInput = { 'avante' },
        markdown = { 'lsp', 'path', 'snippets', 'buffer' },
        text = { 'path', 'snippets', 'buffer' },
        gitcommit = { 'path', 'snippets', 'buffer' },
      },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        avante = {
          name = 'Avante',
          module = 'blink-cmp-avante',
        },
      },
    },

    snippets = { preset = 'luasnip' },

    fuzzy = { implementation = 'lua' },

    signature = { enabled = true },
  },
}
