return {
    {
        "folke/lazydev.nvim",
        config = function ()
            require("lazydev").setup({
                library = {
                    { path = "nvim-dap-ui" },
                },
            })
        end,
    },
    {
        "christianchiarulli/neovim-codicons",
    },
    {
        "nvim-lua/plenary.nvim",
    },
}
