return {
  'loctvl842/monokai-pro.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    transparent_background = false,
    terminal_colors = true,
    devicons = true,
    styles = {
      comment = { italic = true },
      keyword = { italic = true },
      type = { italic = true },
      storageclass = { italic = true },
      structure = { italic = true },
      parameter = { italic = true },
      annotation = { italic = true },
      tag_attribute = { italic = true },
    },
    -- filter options: classic | octagon | pro | machine | ristretto | spectrum
    filter = 'pro',
    inc_search = 'background',
    background_clear = {},
    plugins = {
      bufferline = { underline_selected = false, underline_visible = false },
      indent_blankline = { context_highlight = 'default', context_start_underline = false },
    },
  },
  config = function(_, opts)
    require('monokai-pro').setup(opts)
    vim.cmd.colorscheme('monokai-pro')
  end,
}
