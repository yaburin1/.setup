return {
    "mfussenegger/nvim-lint",
    event = { "ModeChanged", "CursorHold", "TextChanged" },
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            -- javascript = { "eslint" },
            -- typescript = { "eslint" },
            -- javascriptreact = { "eslint" },
            -- typescriptreact = { "eslint" },
            -- rust = { "clippy" },
        }
        --リンターを実行するコマンド
        local api = vim.api
        api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
            group = api.nvim_create_augroup("nvim_lint", {}),
            callback = function()
                require("lint").try_lint()
            end,
        })
    end,
}
