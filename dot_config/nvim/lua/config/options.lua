-- set number
vim.opt.number = true
vim.opt.relativenumber = true

-- set 1 tab to 4 spaces
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- use system clipboard
vim.opt.clipboard = "unnamedplus"

-- useful when strings to be replaced are far from each other
vim.opt.inccommand = "split"

-- ignore case when searching and typing vim commands
vim.opt.ignorecase = true

-- enable RGB
vim.opt.termguicolors = true

-- better visual block support
vim.opt.virtualedit = "block"

-- leader key
vim.g.mapleader = " "

-- fold options
vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "1"
vim.opt.foldenable = false
