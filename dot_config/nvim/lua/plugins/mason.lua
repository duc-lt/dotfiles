return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
            local pylsp = require("mason-registry").get_package("python-lsp-server")
            pylsp:on("install:success", function()
                local venv_path = os.getenv("VIRTUAL_ENV") or vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/python-lsp-server/venv")
                local pip_path = venv_path .. "/bin/pip"
                local args = {
                    pip_path,
                    "install",
                    "-q",
                    "python-lsp-ruff",
                    "pylsp-mypy",
                }

                os.execute(table.concat(args, " "))
            end)
        end,
    },
}
