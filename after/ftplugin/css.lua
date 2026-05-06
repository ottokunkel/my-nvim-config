vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo.foldenable = true
vim.wo.foldlevel = 99

vim.keymap.set('n', '<leader>zm', function()
  vim.wo.foldmethod = 'manual'
  vim.notify('CSS folds set to manual for this window')
end, { buffer = true, desc = 'Use manual folds in CSS' })
