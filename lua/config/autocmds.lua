-- ================================
-- AUTO COMMANDS 
-- ================================-


-- Highlight text which was yanked
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
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





