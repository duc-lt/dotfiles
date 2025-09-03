-- basic configs
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.eol = true
vim.opt.hlsearch = false
vim.opt.winborder = "rounded"
vim.opt.smartindent = true
vim.g.mapleader = " "

-- scrolling with cursor at the middle of the view
vim.keymap.set("n", "<C-d>", "zz<C-d>")
vim.keymap.set("n", "<C-u>", "zz<C-u>")

-- colorscheme
vim.cmd.colorscheme("kanagawa-wave")

-- code completion
vim.opt.completeopt = "menuone,noinsert,popup,fuzzy"
-- vim.opt.complete = ".,o"
vim.opt.pumheight = 7
-- vim.opt.autocomplete = true
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, {
				autotrigger = true,
				convert = function(item)
					local abbr = item.label
					abbr = abbr:gsub("%b()", ""):gsub("%b{}", "")
					abbr = abbr:match("[%w_.]+.*") or abbr
					abbr = #abbr > 15 and abbr:sub(1, 14) .. "…" or abbr

					-- Cap return value field to 15 chars
					local menu = item.detail or ""
					menu = #menu > 15 and menu:sub(1, 14) .. "…" or menu

					return { abbr = abbr, menu = menu }
				end,
			})
		end
	end,
})

-- code diagnostics
vim.diagnostic.config({
	update_in_insert = true,
})

-- more code configs
vim.keymap.set("n", "<leader>F", vim.lsp.buf.format)
vim.keymap.set("n", "grd", vim.lsp.buf.definition)
vim.keymap.set("n", "grD", vim.lsp.buf.declaration)

local function do_open(uri)
	for i in string.gmatch(uri, "([^:])") do
		print(i)
	end
	local cmd, err = vim.ui.open(uri)
	local rv = cmd and cmd:wait(1000) or nil
	if cmd and rv and rv.code ~= 0 then
		err = ('vim.ui.open: command %s (%d): %s'):format(
			(rv.code == 124 and 'timeout' or 'failed'),
			rv.code,
			vim.inspect(cmd.cmd)
		)
	end
	return err
end
vim.keymap.set("n", "gx", function()
	for _, url in ipairs(require('vim.ui')._get_urls()) do
		local err = do_open(url)
		if err then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end
end)
