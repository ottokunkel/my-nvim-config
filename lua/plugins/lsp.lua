return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'mason-org/mason.nvim',
      ---@module 'mason.settings'
      ---@type MasonSettings
      ---@diagnostic disable-next-line: missing-fields
      opts = {},
    },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    {
      'folke/lazydev.nvim',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },

    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gK', vim.lsp.buf.hover, 'Hover Documentation')
        map('gT', function()
          local params = vim.lsp.util.make_position_params(0, 'utf-8')
          vim.lsp.buf_request_all(0, 'textDocument/typeDefinition', params, function(results)
            local locations = {}

            for _, result in pairs(results) do
              if result.result then
                if vim.tbl_islist(result.result) then
                  vim.list_extend(locations, result.result)
                else
                  table.insert(locations, result.result)
                end
              end
            end

            if vim.tbl_isempty(locations) then
              vim.notify('No type definition found', vim.log.levels.INFO)
              return
            end

            vim.lsp.util.preview_location(locations[1], {
              border = 'rounded',
              focusable = true,
            })
          end)
        end, 'Peek Type Definition')

        local function cursor_is_on_tag_capture(buf)
          local cursor = vim.api.nvim_win_get_cursor(0)
          local ok, captures = pcall(vim.treesitter.get_captures_at_pos, buf, cursor[1] - 1, cursor[2])
          if not ok then return false end

          for _, capture in ipairs(captures) do
            local name = type(capture) == 'table' and capture.capture or capture
            if type(name) == 'string' and name:match '^tag' then return true end
          end

          return false
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = function()
              if cursor_is_on_tag_capture(event.buf) then
                vim.lsp.buf.clear_references()
                return
              end

              vim.lsp.buf.document_highlight()
            end,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    ---@type table<string, vim.lsp.Config>
    local servers = {
      pyright = {},
      ruff = {},

      ts_ls = {},
      eslint = {},

      rust_analyzer = {},
      clangd = {},

      html = {},
      emmet_language_server = {},
      cssls = {
        settings = {
          css = { lint = { unknownAtRules = 'ignore' } },
          scss = { lint = { unknownAtRules = 'ignore' } },
          less = { lint = { unknownAtRules = 'ignore' } },
        },
      },
      tailwindcss = {},

      jsonls = {},
      yamlls = {},
      taplo = {},

      marksman = {},

      lua_ls = {
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = false

          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
              checkThirdParty = false,
              library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                '${3rd}/luv/library',
                '${3rd}/busted/library',
              }),
            },
          })
        end,
        ---@type lspconfig.settings.lua_ls
        settings = {
          Lua = {
            format = { enable = false },
          },
        },
      },
    }

    -- Server activation is handled explicitly below.
    require('mason-lspconfig').setup { automatic_enable = false }

    local ensure_installed = vim.tbl_keys(servers)
    for i, name in ipairs(ensure_installed) do
      if name == 'clangd' then
        -- Use a system clangd on platforms without a Mason binary, such as Linux ARM64.
        ensure_installed[i] = { name, condition = function() return vim.fn.executable 'clangd' == 0 end }
      end
    end
    -- Formatters belong in Mason's install list, not the LSP server table.
    vim.list_extend(ensure_installed, { 'stylua' })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    for name, server in pairs(servers) do
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
  end,
}
