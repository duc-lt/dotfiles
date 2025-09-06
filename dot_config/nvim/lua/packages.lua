-- vim.pack.add({
-- 	{ src = "https://github.com/rebelot/kanagawa.nvim" },
-- 	{ src = "https://github.com/stevearc/oil.nvim" },
-- 	{ src = "https://github.com/ibhagwan/fzf-lua" },
-- })

-- TODO: remove current plugin manager in favour of vim.pack when nvim 0.12 is released
local package_path = vim.fn.stdpath("data") .. "/site/pack/core/opt"
local plugman_path = package_path .. "mini.deps"
if not (vim.uv or vim.loop).fs_stat(plugman_path) then
	local plugman_repo = "https://github.com/nvim-mini/mini.deps"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=main", plugman_repo, plugman_path })
end
vim.opt.rtp:prepend(plugman_path)

require("mini.deps").setup({
	path = {
		package = package_path,
	},
})
local add = MiniDeps.add
add({ source = "rebelot/kanagawa.nvim" })
add({ source = "stevearc/oil.nvim" })
add({ source = "ibhagwan/fzf-lua" })
add({ source = "nvim-mini/mini.completion" })
add({ source = "sindrets/diffview.nvim" })
add({ source = "lewis6991/gitsigns.nvim" })
