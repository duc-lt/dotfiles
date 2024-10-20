return {
    {
        "natecraddock/workspaces.nvim",
        config = function()
            require("workspaces").setup({
                hooks = {
                    open = function()
                        local find_io = io.popen("find . -name pyvenv.cfg -exec dirname {} \\;")
                        local venv_path = find_io:read("*l")
                        find_io:close()
                        if venv_path ~= nil and venv_path ~= "" then
                            local status = os.execute(string.format("ls %s/bin/ruff 2>/dev/null", venv_path))
                            if status ~= 0 then
                                os.execute(string.format("%s/bin/pip install -q ruff", venv_path))
                            end
                        end
                    end,
                },
            })
        end,
    },
    {
        "natecraddock/sessions.nvim",
        config = function()
            require("sessions").setup()
        end,
    },
}
