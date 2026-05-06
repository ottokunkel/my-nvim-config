vim.cmd.highlight('clear')

if vim.fn.exists('syntax_on') == 1 then
  vim.cmd.syntax('reset')
end

vim.o.background = 'dark'
vim.g.colors_name = 'dracula-plus'

local colors = {
  bg = '#212121',
  term_black = '#21222c',
  bg_dark = '#191a21',
  bg_float = '#282828',
  fg = '#f8f8f2',
  muted = '#545454',
  selection = '#3a3a3a',
  comment = '#545454',
  red = '#ff5555',
  red_bright = '#ff6e6e',
  orange = '#ffcb6b',
  yellow = '#ffcb6b',
  green = '#50fa7b',
  green_bright = '#69ff94',
  cyan = '#8be9fd',
  cyan_bright = '#a4ffff',
  blue = '#82aaff',
  purple = '#c792ea',
  purple_bright = '#d6acff',
  pink = '#c792ea',
  pink_bright = '#ff92df',
  white = '#f8f8f2',
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local transparent = 'NONE'

hi('Normal', { fg = colors.fg, bg = transparent })
hi('NormalNC', { fg = colors.fg, bg = transparent })
hi('NormalFloat', { fg = colors.fg, bg = transparent })
hi('FloatBorder', { fg = colors.muted, bg = transparent })
hi('FloatTitle', { fg = colors.purple, bg = transparent, bold = true })
hi('ColorColumn', { bg = colors.bg_float })
hi('Cursor', { fg = colors.bg, bg = colors.fg })
hi('CursorColumn', { bg = colors.bg_float })
hi('CursorLine', { bg = colors.bg_float })
hi('CursorLineNr', { fg = colors.yellow, bg = transparent, bold = true })
hi('LineNr', { fg = colors.muted, bg = transparent })
hi('SignColumn', { fg = colors.muted, bg = transparent })
hi('FoldColumn', { fg = colors.muted, bg = transparent })
hi('EndOfBuffer', { fg = colors.bg_float, bg = transparent })
hi('NonText', { fg = colors.selection, bg = transparent })
hi('WinSeparator', { fg = colors.selection, bg = transparent })
hi('VertSplit', { fg = colors.selection, bg = transparent })

hi('Visual', { bg = colors.selection })
hi('VisualNOS', { bg = colors.selection })
hi('Search', { fg = colors.bg, bg = colors.yellow })
hi('IncSearch', { fg = colors.bg, bg = colors.orange })
hi('CurSearch', { fg = colors.bg, bg = colors.orange })
hi('Substitute', { fg = colors.bg, bg = colors.pink })
hi('MatchParen', { fg = colors.yellow, bg = colors.selection, bold = true })

hi('Pmenu', { fg = colors.fg, bg = colors.bg_float })
hi('PmenuSel', { fg = colors.bg, bg = colors.purple })
hi('PmenuSbar', { bg = colors.selection })
hi('PmenuThumb', { bg = colors.muted })
hi('WildMenu', { fg = colors.bg, bg = colors.cyan })

hi('StatusLine', { fg = colors.fg, bg = colors.bg_float })
hi('StatusLineNC', { fg = colors.muted, bg = colors.bg_dark })
hi('TabLine', { fg = colors.muted, bg = colors.bg_float })
hi('TabLineFill', { fg = colors.muted, bg = transparent })
hi('TabLineSel', { fg = colors.fg, bg = colors.selection, bold = true })
hi('WinBar', { fg = colors.fg, bg = transparent })
hi('WinBarNC', { fg = colors.muted, bg = transparent })

hi('Comment', { fg = colors.comment, italic = true })
hi('Constant', { fg = colors.purple })
hi('String', { fg = colors.yellow })
hi('Character', { fg = colors.yellow })
hi('Number', { fg = colors.purple })
hi('Boolean', { fg = colors.purple })
hi('Float', { fg = colors.purple })
hi('Identifier', { fg = colors.fg })
hi('Function', { fg = colors.green })
hi('Statement', { fg = colors.pink })
hi('Conditional', { fg = colors.pink })
hi('Repeat', { fg = colors.pink })
hi('Label', { fg = colors.pink })
hi('Operator', { fg = colors.pink })
hi('Keyword', { fg = colors.pink, italic = true })
hi('Exception', { fg = colors.pink })
hi('PreProc', { fg = colors.pink })
hi('Include', { fg = colors.pink })
hi('Define', { fg = colors.pink })
hi('Macro', { fg = colors.pink })
hi('PreCondit', { fg = colors.pink })
hi('Type', { fg = colors.blue })
hi('StorageClass', { fg = colors.blue })
hi('Structure', { fg = colors.blue })
hi('Typedef', { fg = colors.blue })
hi('Special', { fg = colors.cyan })
hi('SpecialChar', { fg = colors.cyan })
hi('Tag', { fg = colors.pink })
hi('Delimiter', { fg = colors.fg })
hi('SpecialComment', { fg = colors.comment, italic = true })
hi('Debug', { fg = colors.orange })
hi('Underlined', { fg = colors.cyan, underline = true })
hi('Ignore', { fg = colors.muted })
hi('Error', { fg = colors.red })
hi('Todo', { fg = colors.bg, bg = colors.yellow, bold = true })
hi('Title', { fg = colors.purple, bold = true })
hi('Directory', { fg = colors.cyan })
hi('Question', { fg = colors.green })
hi('MoreMsg', { fg = colors.green })
hi('ModeMsg', { fg = colors.fg, bold = true })
hi('WarningMsg', { fg = colors.orange })
hi('ErrorMsg', { fg = colors.red })

hi('DiffAdd', { fg = colors.green, bg = '#243b2f' })
hi('DiffChange', { fg = colors.orange, bg = '#3a3346' })
hi('DiffDelete', { fg = colors.red, bg = '#3b2633' })
hi('DiffText', { fg = colors.yellow, bg = '#51465c', bold = true })
hi('Added', { fg = colors.green })
hi('Changed', { fg = colors.orange })
hi('Removed', { fg = colors.red })

hi('DiagnosticError', { fg = colors.red })
hi('DiagnosticWarn', { fg = colors.orange })
hi('DiagnosticInfo', { fg = colors.cyan })
hi('DiagnosticHint', { fg = colors.green })
hi('DiagnosticOk', { fg = colors.green })
hi('DiagnosticUnderlineError', { sp = colors.red, undercurl = true })
hi('DiagnosticUnderlineWarn', { sp = colors.orange, undercurl = true })
hi('DiagnosticUnderlineInfo', { sp = colors.cyan, undercurl = true })
hi('DiagnosticUnderlineHint', { sp = colors.green, undercurl = true })
hi('DiagnosticVirtualTextError', { fg = colors.red, bg = transparent })
hi('DiagnosticVirtualTextWarn', { fg = colors.orange, bg = transparent })
hi('DiagnosticVirtualTextInfo', { fg = colors.cyan, bg = transparent })
hi('DiagnosticVirtualTextHint', { fg = colors.green, bg = transparent })

hi('GitSignsAdd', { fg = colors.green, bg = transparent })
hi('GitSignsChange', { fg = colors.orange, bg = transparent })
hi('GitSignsDelete', { fg = colors.red, bg = transparent })

hi('TelescopeNormal', { fg = colors.fg, bg = transparent })
hi('TelescopeBorder', { fg = colors.muted, bg = transparent })
hi('TelescopePromptNormal', { fg = colors.fg, bg = colors.bg_float })
hi('TelescopePromptBorder', { fg = colors.purple, bg = colors.bg_float })
hi('TelescopePromptTitle', { fg = colors.bg, bg = colors.purple, bold = true })
hi('TelescopePreviewTitle', { fg = colors.bg, bg = colors.green, bold = true })
hi('TelescopeResultsTitle', { fg = colors.bg, bg = colors.blue, bold = true })
hi('TelescopeSelection', { fg = colors.fg, bg = colors.selection })
hi('TelescopeMatching', { fg = colors.yellow, bold = true })

hi('@comment', { fg = colors.comment, italic = true })
hi('@constant', { fg = colors.purple })
hi('@constant.builtin', { fg = colors.purple, italic = true })
hi('@string', { fg = colors.yellow })
hi('@character', { fg = colors.yellow })
hi('@number', { fg = colors.purple })
hi('@boolean', { fg = colors.purple })
hi('@float', { fg = colors.purple })
hi('@function', { fg = colors.green })
hi('@function.builtin', { fg = colors.cyan })
hi('@function.macro', { fg = colors.green })
hi('@constructor', { fg = colors.blue })
hi('@parameter', { fg = colors.orange })
hi('@variable', { fg = colors.fg })
hi('@variable.builtin', { fg = colors.purple, italic = true })
hi('@property', { fg = colors.blue })
hi('@field', { fg = colors.blue })
hi('@keyword', { fg = colors.pink, italic = true })
hi('@keyword.function', { fg = colors.pink, italic = true })
hi('@keyword.operator', { fg = colors.pink })
hi('@keyword.return', { fg = colors.pink, italic = true })
hi('@operator', { fg = colors.pink })
hi('@type', { fg = colors.blue })
hi('@type.builtin', { fg = colors.blue, italic = true })
hi('@tag', { fg = colors.pink })
hi('@tag.attribute', { fg = colors.green })
hi('@tag.delimiter', { fg = colors.fg })
hi('@punctuation.delimiter', { fg = colors.fg })
hi('@punctuation.bracket', { fg = colors.fg })
hi('@punctuation.special', { fg = colors.pink })
hi('@markup.heading', { fg = colors.purple, bold = true })
hi('@markup.strong', { bold = true })
hi('@markup.italic', { italic = true })
hi('@markup.strikethrough', { strikethrough = true })
hi('@markup.link', { fg = colors.cyan, underline = true })
hi('@markup.link.url', { fg = colors.cyan, underline = true })
hi('@markup.raw', { fg = colors.green })
hi('@markup.list', { fg = colors.pink })

vim.g.terminal_color_0 = colors.term_black
vim.g.terminal_color_1 = colors.red
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.yellow
vim.g.terminal_color_4 = colors.blue
vim.g.terminal_color_5 = colors.pink
vim.g.terminal_color_6 = colors.cyan
vim.g.terminal_color_7 = colors.fg
vim.g.terminal_color_8 = colors.muted
vim.g.terminal_color_9 = colors.red_bright
vim.g.terminal_color_10 = colors.green_bright
vim.g.terminal_color_11 = colors.yellow
vim.g.terminal_color_12 = colors.purple_bright
vim.g.terminal_color_13 = colors.pink_bright
vim.g.terminal_color_14 = colors.cyan_bright
vim.g.terminal_color_15 = colors.white
