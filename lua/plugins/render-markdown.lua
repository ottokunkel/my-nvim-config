return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    heading = {
      sign = false,
      icons = {},               -- no #/##/### icon replacements
      backgrounds = {},         -- no colored heading backgrounds
      foregrounds = {
        'RenderMarkdownH1',
        'RenderMarkdownH2',
        'RenderMarkdownH3',
        'RenderMarkdownH4',
        'RenderMarkdownH5',
        'RenderMarkdownH6',
      },
      width = 'block',
    },
    code = {
      sign = false,
      style = 'normal',         -- no language icon / no background fill
      border = 'thin',
    },
    bullet = { enabled = false },
    checkbox = { enabled = false },
    dash = { enabled = false },
    quote = { repeat_linebreak = false },
    pipe_table = { style = 'normal' },
    link = { enabled = false },
  },
}
