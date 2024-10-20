return {
    -- lsp
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "gopls",
                    "lua_ls",
                    "pylsp",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "natecraddock/workspaces.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            lspconfig.gopls.setup({
                capabilities = capabilities,
                settings = {
                    gopls = {
                        completeUnimported = true,
                    },
                },
            })

            function get_ruff_path()
                local cwd_handle = io.popen("pwd")
                local cwd_path = cwd_handle:read("*l")
                cwd_handle:close()
                local venv_handle = io.popen(string.format("find %s -name pyvenv.cfv -exec dirname {} \\;", cwd_path))
                local venv_path = venv_handle:read("*l")
                venv_handle:close()
                if venv_path ~= nil and venv_path ~= "" then
                    return venv_path .. "/bin/ruff"
                end
                return vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/bin/ruff")
            end

            lspconfig.pylsp.setup({
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                enabled = false,
                            },
                            preload = {
                                enabled = false,
                            },
                            pyflakes = {
                                enabled = false,
                            },
                            autopep8 = {
                                enabled = false,
                            },
                            pylsp_mypy = {
                                enabled = true,
                            },
                            ruff = {
                                enabled = true,
                                formatEnabled = true,
                                executable = get_ruff_path(),
                            },
                        },
                    },
                },
            })

            vim.keymap.set("n", "<leader>I", vim.lsp.buf.format, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
            vim.keymap.set("n", "<leader>td", vim.lsp.buf.type_definition, {})
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },

    -- dap
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "delve",
                    "python",
                },
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            -- keymaps
            vim.keymap.set("n", "<leader>dc", function()
                dap.continue()
            end)
            vim.keymap.set("n", "<leader>dl", function()
                dap.step_over()
            end)
            vim.keymap.set("n", "<leader>dj", function()
                dap.step_into()
            end)
            vim.keymap.set("n", "<leader>dk", function()
                dap.step_out()
            end)
            vim.keymap.set("n", "<leader>dt", function()
                dap.toggle_breakpoint()
            end)
            vim.keymap.set("n", "<leader>dx", function()
                dap.clear_breakpoints()
            end)
            vim.keymap.set("n", "<leader>dr", function()
                dap.repl.open()
            end)

            -- adapters
            dap.adapters.delve = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "dlv",
                    args = { "dap", "-l", "127.0.0.1:${port}" },
                },
            }
            dap.configurations.go = {
                {
                    type = "delve",
                    name = "debug",
                    console = "integratedTerminal",
                    request = "launch",
                    program = "${file}",
                },
                {
                    type = "delve",
                    name = "debug test",
                    request = "launch",
                    mode = "test",
                    program = "${file}",
                },
                {
                    type = "delve",
                    name = "debug test (go.mod)",
                    request = "launch",
                    mode = "test",
                    program = "./${relativeFileDirname}",
                },
            }

            dap.adapters.python = function(cb, config)
                if config.request == "attach" then
                    ---@diagnostic disable-next-line: undefined-field
                    local port = (config.connect or config).port
                    ---@diagnostic disable-next-line: undefined-field
                    local host = (config.connect or config).host or "127.0.0.1"
                    cb({
                        type = "server",
                        port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                        host = host,
                        options = {
                            source_filetype = "python",
                        },
                    })
                else
                    cb({
                        type = "executable",
                        command = vim.fn.stdpath("data") .. "mason/packages/debugpy/debugpy",
                        args = { "-m", "debugpy.adapter" },
                        options = {
                            source_filetype = "python",
                        },
                    })
                end
            end
            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    pythonPath = function()
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                            return cwd .. "/venv/bin/python"
                        elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                            return cwd .. "/.venv/bin/python"
                        else
                            return "/usr/bin/python"
                        end
                    end,
                },
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },

    -- code actions, diagnostics/linters and formatters
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = {
                    "golangci-lint",
                    "stylua",
                    "ruff",
                    "mypy",
                },
            })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local none_ls = require("null-ls")
            none_ls.setup({
                sources = {
                    none_ls.builtins.diagnostics.golangci_lint,
                    none_ls.builtins.formatting.stylua,
                    none_ls.builtins.formatting.black,
                },
            })
        end,
    },
}
