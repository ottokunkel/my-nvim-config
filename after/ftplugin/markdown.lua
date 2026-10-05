local cr = '\n'
local tab = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
local ctrl_u = vim.api.nvim_replace_termcodes('<C-u>', true, false, true)
local ctrl_t = vim.api.nvim_replace_termcodes('<C-t>', true, false, true)
local mini_pairs_cr = vim.api.nvim_replace_termcodes('<CR>', true, false, true)

-- Visually wrap prose without inserting newline characters while typing.
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.textwidth = 0
vim.opt_local.formatoptions:remove('t')

-- Neovim applies wrapping to an entire window, so it cannot keep prose wrapped
-- while leaving table rows unwrapped in that same window. Toggle wrapping while
-- working on a wide table, then toggle it back for prose.
vim.keymap.set('n', '<leader>tl', function()
  vim.wo.wrap = not vim.wo.wrap
end, {
  buffer = true,
  desc = 'Toggle Markdown line wrapping',
})

local function is_bullet_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''

  return line:match('^%s*[-*]%s') ~= nil or line:match('^%s*[-*]$') ~= nil
end

local function markdown_cr()
  local ok, mini_pairs = pcall(require, 'mini.pairs')
  if ok then
    local pairs_cr = mini_pairs.cr()
    if pairs_cr ~= mini_pairs_cr then return pairs_cr end
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''
  local before_cursor = line:sub(1, col)
  local indent, marker, spacing = before_cursor:match('^(%s*)([-*])(%s*)')

  if marker and (spacing ~= '' or before_cursor == indent .. marker) then
    local bullet = marker .. (spacing ~= '' and spacing or ' ')
    local clear_autoindent = indent ~= '' and ctrl_u or ''
    return cr .. clear_autoindent .. indent .. bullet
  end

  return cr
end

local function markdown_tab()
  if is_bullet_line() then return ctrl_t end

  return tab
end

vim.keymap.set('i', '<CR>', markdown_cr, {
  buffer = true,
  expr = true,
  replace_keycodes = false,
  desc = 'Continue Markdown bullet list',
})

vim.keymap.set('i', '<Tab>', markdown_tab, {
  buffer = true,
  expr = true,
  replace_keycodes = false,
  desc = 'Indent Markdown bullet list',
})
