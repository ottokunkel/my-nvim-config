return {
  'HakonHarnes/img-clip.nvim',
  event = 'VeryLazy',
  opts = {
    default = {
      dir_path = 'assets',
      relative_to_current_file = true,
      use_absolute_path = false,
    },
    filetypes = {
      markdown = {
        template = '![$CURSOR]($FILE_PATH)',
        url_encode_path = true,
        download_images = false,
      },
    },
  },
  keys = {
    { '<leader>pi', '<cmd>PasteImage<cr>', desc = 'Paste image into Markdown' },
  },
}
