-- ================================
-- AUTO COMMANDS 
-- ================================-


-- Highlight text which was yanked
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Pick up edits made by external tools (for example, an AI coding agent).
-- `autoread` reloads clean buffers; modified buffers still get Neovim's
-- conflict warning instead of having local work overwritten.
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  desc = 'Reload files changed outside Neovim',
  group = vim.api.nvim_create_augroup('external-file-refresh', { clear = true }),
  callback = function()
    if vim.fn.mode() ~= 'c' then vim.cmd 'checktime' end
  end,
})

-- [ INSTALLS LAZYVIM PLUGIN MANAGER ] -- 
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)


-- on terminal open, insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("startinsert")
  end,
})


-- color inline markdown code (`...`) without a background highlight
local function style_markdown_inline_code()
  vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { fg = "#ff9e64", bg = "NONE" })
  vim.api.nvim_set_hl(0, "markdownCode", { fg = "#ff9e64", bg = "NONE" })
end
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("markdown-inline-code-style", { clear = true }),
  callback = style_markdown_inline_code,
})
style_markdown_inline_code()


-- Keep the mode cursors visible after any colorscheme changes.
local function style_mode_cursors()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local normal_bg = normal.bg or 0x141415
  local normal_fg = normal.fg or 0xcdcdcd

  vim.api.nvim_set_hl(0, "Cursor", { fg = normal_bg, bg = normal_fg })
  vim.api.nvim_set_hl(0, "iCursor", { fg = normal_bg, bg = 0xff9e64 })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("mode-cursor-style", { clear = true }),
  callback = style_mode_cursors,
})
style_mode_cursors()

