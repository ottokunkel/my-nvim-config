return {
  'jvgrootveld/telescope-zoxide',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>cz',
      function() require('telescope').extensions.zoxide.list() end,
      desc = 'Zoxide jump (cd to dir)',
    },
  },
  config = function()
    require('telescope').load_extension('zoxide')
  end,
}
