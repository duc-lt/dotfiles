return {
	cmd = { os.getenv("HOME") .. "/go/bin/gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.mod", "go.sum", "go.work", ".git" },
}
