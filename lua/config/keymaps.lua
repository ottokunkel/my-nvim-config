-- ================================
-- KEYMAPS
-- ================================
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- clears highlights on escape
-- Diagnostic Config & Keymaps
vim.diagnostic.config {
  update_in_insert = false,   -- updates don't update while typing
  severity_sort = true,       -- diagnostics are sorted by importance
  float = { border = 'rounded', source = 'if_many' },   -- controls popup window
  underline = { severity = { min = vim.diagnostic.severity.WARN } },  -- only underline warnings and errors
  virtual_text = true,        -- Text shows up at the end of the line
  virtual_lines = false,      -- Text shows up underneath the line, with virtual lines
  jump = { float = true },    -- jumps between diagnostics with `[d` and `]d`
}
-- open diagnostic quickfix list with leader key
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic Quickfix List' })

-- exit terminal mode with two ESC rather than ctrl+\ ctrl+n
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit Terminal Mode' })
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><cmd>TmuxNavigateLeft<cr>]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><cmd>TmuxNavigateDown<cr>]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><cmd>TmuxNavigateUp<cr>]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><cmd>TmuxNavigateRight<cr>]])

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Window Left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Window Right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Window Down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Window Up' })

-- Open splits in a chosen direction (new split shows the Alpha dashboard)
local function split_alpha(cmd)
  return function()
    vim.cmd(cmd)
    vim.cmd 'Alpha'
  end
end
vim.keymap.set('n', '<leader>wk', split_alpha 'aboveleft split',  { desc = 'Split Above' })
vim.keymap.set('n', '<leader>wj', split_alpha 'belowright split', { desc = 'Split Below' })
vim.keymap.set('n', '<leader>wh', split_alpha 'aboveleft vsplit', { desc = 'Split Left' })
vim.keymap.set('n', '<leader>wl', split_alpha 'belowright vsplit',{ desc = 'Split Right' })

-- Close the current buffer; fall back to the Alpha dashboard when no other listed buffers remain
vim.keymap.set('n', '<leader>bd', function()
  local cur = vim.api.nvim_get_current_buf()
  local has_other = false
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted and vim.bo[b].buftype == '' then
      has_other = true
      break
    end
  end
  if has_other then
    vim.cmd 'bprevious'
    vim.cmd('bdelete ' .. cur)
  else
    vim.cmd 'Alpha'
    vim.cmd('bdelete ' .. cur)
  end
end, { desc = 'Close Buffer (Alpha if last)' })


