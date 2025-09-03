-- vim.pack.add({
-- 	{ src = "https://github.com/rebelot/kanagawa.nvim" },
-- 	{ src = "https://github.com/stevearc/oil.nvim" },
-- 	{ src = "https://github.com/ibhagwan/fzf-lua" },
-- })

-- TODO: remove lazy.nvim when nvim 0.12 is released
local lazypath = vim.fn.stdpath("data") .. "/site/pack/core/opt/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		{ "rebelot/kanagawa.nvim" },
		{ "stevearc/oil.nvim" },
		{ "ibhagwan/fzf-lua" },
	},
	checker = { enabled = true },
})
