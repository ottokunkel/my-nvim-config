return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
  ft = { 'markdown' },
  build = 'cd app && yarn install',
  init = function()
    require('config.markdown_preview_typora').setup()
    vim.g.mkdp_auto_close = 1
  end,
  keys = {
    { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown Preview Toggle', ft = 'markdown' },
    {
      '<leader>mT',
      function()
        require('config.markdown_preview_typora').select_theme()
      end,
      desc = 'Markdown Preview Theme',
      ft = 'markdown',
    },
  },
}
