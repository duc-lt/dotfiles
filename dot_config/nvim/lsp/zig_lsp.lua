return {
	cmd = { vim.fn.stdpath("data") .. "/lspservers/zig/lsp/build/zig-out/bin/zls" },
	filetypes = { "zig", "zir", "zon" },
	root_markers = { "zls.json", "build.zig", ".git" },
	-- workspace_required = false,
	settings = {
		zls = {
			zig_exe_path = os.getenv("HOME") .. "/zig/nightly/zig",
		},
	},
}
