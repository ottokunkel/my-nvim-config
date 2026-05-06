-- ================================
-- KEYMAPS
-- ================================
local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>') -- clears highlights on escape
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
map('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Diagnostic Quickfix List' })
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- File / save / quit (LazyVim-style)
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

-- Better up/down on wrapped lines
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Down' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Up' })

-- Keep cursor centered on half-page jumps and search nav
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up' })
map('n', 'n', 'nzzzv', { desc = 'Next search result' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search result' })

-- Better indenting (keep selection)
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Move selected lines up/down
map('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Buffer navigation (LazyVim-style)
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- Folds
map('n', '<leader>za', 'za', { desc = 'Toggle Fold' })
map('n', '<leader>zA', 'zA', { desc = 'Toggle All Folds Here' })
map('n', '<leader>zo', 'zR', { desc = 'Open All Folds' })
map('n', '<leader>zc', 'zM', { desc = 'Close All Folds' })

-- exit terminal mode with two ESC rather than ctrl+\ ctrl+n
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit Terminal Mode' })
map('t', '<C-h>', [[<C-\><C-n><cmd>TmuxNavigateLeft<cr>]])
map('t', '<C-j>', [[<C-\><C-n><cmd>TmuxNavigateDown<cr>]])
map('t', '<C-k>', [[<C-\><C-n><cmd>TmuxNavigateUp<cr>]])
map('t', '<C-l>', [[<C-\><C-n><cmd>TmuxNavigateRight<cr>]])

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Window Left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Window Right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Window Down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Window Up' })

-- Window management (LazyVim-style)
map('n', '<leader>w-', '<C-W>s', { desc = 'Split Window Below' })
map('n', '<leader>w|', '<C-W>v', { desc = 'Split Window Right' })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window' })
map('n', '<leader>ww', '<C-W>p', { desc = 'Other Window' })
map('n', '<leader>wo', '<cmd>only<cr>', { desc = 'Close Other Windows' })

-- Open splits in a chosen direction (new split shows the Alpha dashboard)
local function split_alpha(cmd)
  return function()
    vim.cmd(cmd)
    vim.cmd 'Alpha'
  end
end
map('n', '<leader>wk', split_alpha 'aboveleft split',  { desc = 'Split Above (Alpha)' })
map('n', '<leader>wj', split_alpha 'belowright split', { desc = 'Split Below (Alpha)' })
map('n', '<leader>wh', split_alpha 'aboveleft vsplit', { desc = 'Split Left (Alpha)' })
map('n', '<leader>wl', split_alpha 'belowright vsplit',{ desc = 'Split Right (Alpha)' })

-- Close the current buffer; fall back to the Alpha dashboard when no other listed buffers remain
map('n', '<leader>bd', function()
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

