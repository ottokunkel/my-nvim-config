-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

---@module 'lazy'
---@type LazySpec
return {
  'lewis6991/gitsigns.nvim',
  ---@module 'gitsigns'
  ---@type Gitsigns.Config
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Next Hunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Previous Hunk' })

      -- Actions
      -- visual mode
      map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'Stage Hunk' })
      map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'Reset Hunk' })
      -- normal mode
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage Hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset Hunk' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage Buffer' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview Hunk' })
      map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'Preview Hunk Inline' })
      map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'Blame Line' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff Against Index' })
      map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'Diff Against Last Commit' })
      map('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = 'Quickfix (All Files)' })
      map('n', '<leader>hq', gitsigns.setqflist, { desc = 'Quickfix (Current File)' })
      -- Toggles
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Line Blame' })
      map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'Word Diff' })

      -- Text object
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
    end,
  },
}
