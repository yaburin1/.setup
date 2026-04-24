return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" }, --*
    cmd = { "ConformInfo" }, --*

    keys = {
        {
            "<leader>af",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "n",
            desc = "Format buffer",
        },
    },
    opts = {
        formatters_by_ft = {
            -- ["*"] = { "trim_whitespace", "trim_newlines" },
            -- javascript = { "biome" },
            -- typescript = { "biome" },
            -- javascriptreact = { "biome" },
            -- typescriptreact = { "biome" },
            -- lua = { "stylua" },
            -- htmldjango = { "djlint" },
            rust = { "rustfmt" },
            -- bash = { "shfmt" },
            -- sh = { "shfmt" },
            yaml = { "yamlfmt" },
            yml = { "yamlfmt" },
            markdown = { "markdownlint" }
        },
        format_on_save = function()
            local v = vim
            local fn = v.fn
            local pos = fn.getpos(".")
            if fn.search("\r", "n") > 0 then
                v.cmd("silent! %s/\r//g")
            end
            fn.setpos(".", pos)
            return { timeout_ms = 500, lsp_format = "fallback" }
        end,
    },
}
