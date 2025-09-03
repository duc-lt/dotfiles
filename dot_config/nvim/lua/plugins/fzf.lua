local fzf = require("fzf-lua")
fzf.setup({
	"hide",
})

vim.keymap.set("n", "<leader>ff", fzf.files)
vim.keymap.set("n", "<leader>fg", fzf.live_grep)
vim.keymap.set("n", "<leader>fb", fzf.buffers)
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document)
