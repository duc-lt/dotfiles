return {
    -- lsp
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function ()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "gopls",
                    "lua_ls"
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function ()
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
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
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
        config = function ()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "delve",
                },
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function ()
            local dap = require("dap")

            -- keymaps
            vim.keymap.set("n", "<leader>dc", function() dap.continue() end)
            vim.keymap.set("n", "<leader>dl", function() dap.step_over() end)
            vim.keymap.set("n", "<leader>dj", function() dap.step_into() end)
            vim.keymap.set("n", "<leader>dk", function() dap.step_out() end)
            vim.keymap.set("n", "<leader>dt", function() dap.toggle_breakpoint() end)
            vim.keymap.set("n", "<leader>dx", function() dap.clear_breakpoints() end)
            vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end)

            -- adapters
            dap.adapters.delve = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "dlv",
                    args = {"dap", "-l", "127.0.0.1:${port}"},
                }
            }
            dap.configurations.go = {
                {
                    type = "delve",
                    name = "debug",
                    console = "integratedTerminal",
                    request = "launch",
                    program = "${file}"
                },
                {
                    type = "delve",
                    name = "debug test",
                    request = "launch",
                    mode = "test",
                    program = "${file}"
                },
                {
                    type = "delve",
                    name = "debug test (go.mod)",
                    request = "launch",
                    mode = "test",
                    program = "./${relativeFileDirname}"
                } 
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function ()
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
                }
            })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function ()
            local none_ls = require("null-ls")
            none_ls.setup({
                sources = {
                    none_ls.builtins.diagnostics.golangci_lint,
                    none_ls.builtins.formatting.stylua,
                },
            })

        end,
    },
}
