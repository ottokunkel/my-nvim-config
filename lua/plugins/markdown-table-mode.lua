return {
  'Kicamon/markdown-table-mode.nvim',
  ft = 'markdown',
  opts = {
    filetype = { '*.md' },
    options = {
      insert = true,
      insert_leave = true,
      pad_separator_line = false,
      align_style = 'default',
    },
  },
  config = function(_, opts)
    require('markdown-table-mode').setup(opts)
    vim.cmd 'Mtm'
  end,
}
