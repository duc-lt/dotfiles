local oil = require("oil")
oil.setup({
	default_file_explorer = true,
	columns = {
		"size",
		"permissions",
		"mtime",
	},
	float = {
		padding = 2,
		max_width = 0.5,
		max_height = 0.5,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
		get_win_title = nil,
		preview_split = "right",
	},
})

vim.keymap.set("n", "<leader>e", oil.toggle_float)
