-- mapping leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- uses a Nerd Font
vim.g.have_nerd_font = true

-- disable netrw so oil.nvim / neo-tree handle directories
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- CONFIG IMPORTS
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

--vim.o.background = 'dark'
-- colorscheme is applied by lua/plugins/monokai-pro.lua after setup()

-- vim: ts=2 sts=2 sw=2 et
