-- ================================
-- OPTIONS
-- ================================
-- [[ Setting options ]]
vim.o.number = true         --make line numbers default
vim.o.mouse = 'a'           -- allows mouse 
vim.opt.mousescroll = 'ver:1,hor:6' -- keep trackpad events to one vertical line
vim.o.smoothscroll = true   -- scroll wrapped text by screen line
vim.o.showmode = false      -- shows if it's in insert/visual/normal
vim.o.cmdheight = 0         -- hide the command line until you type `:` (frees the bottom row for tpipeline)
-- sync clipboard between OS and NVIM
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.linebreak = true   -- wrap long lines at word boundaries when possible

vim.o.wrap = true
vim.o.breakindent = true -- enable break indent (allows to read long lines -> indents them)
vim.o.undofile = true     -- enable undo/redo after closing and reopening a file
vim.o.autoread = true     -- reload unmodified buffers when another process changes the file
vim.o.ignorecase = true   -- case insensitive
vim.o.smartcase = true    -- case sentitive if theres capital letters in search term (use \c at end of term to make insentive \C sensitive) 
vim.o.signcolumn = 'yes'  -- shows git diffs (+/-)
vim.o.statuscolumn = ' %C%s%=%l ' -- add a small left gutter before folds/signs/line numbers
vim.o.updatetime = 250    -- how long to wait after typing to trigger background (LSP/Lint)
vim.o.timeoutlen = 300    -- how long vim waits for mapped key sequence -> combos
vim.o.splitright = true   -- new splits appear to the right
vim.o.splitbelow = true   -- new splits appear below
-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
-- sets tab, trailing spaces, and non-breaking space
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'  -- opens a preview as you type in a split window
vim.o.cursorline = true     -- shows which line you are on (highlights)
vim.o.scrolloff = 10        -- minimal number of screen lines to keep above and below cursor
vim.o.confirm = true        -- dialog to confirm change like :q which wouldn't save
vim.o.termguicolors = true  -- enable 24-bit true color

-- set cursor in terminal
vim.opt.guicursor = {
  "n-v-c:block",   -- normal mode: block
  "i-ci-ve:ver35-iCursor-blinkon0", -- insert mode: visible vertical bar
  "r-cr:hor20",    -- replace mode: underline
  "t:block-TermCursor", -- terminal mode: block
}


vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

-- Folding: use Tree-sitter when available, but keep files open by default.
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldtext = ''
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local fold_open = vim.g.have_nerd_font and '' or '-'
local fold_closed = vim.g.have_nerd_font and '' or '+'
vim.opt.fillchars:append {
  fold = ' ',
  foldopen = fold_open,
  foldsep = ' ',
  foldclose = fold_closed,
}
