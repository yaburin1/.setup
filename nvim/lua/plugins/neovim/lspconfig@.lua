return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    {
        -- [使用]
        -- nvim/after/lsp/<LSP名>.luaで設定上書き
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" }, --*
        config = function()
            vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"
        end,
    },
    {
        -- [必要]
        -- mason
        -- [推奨]
        -- "neovim/nvim-lspconfig" --lsp設定集
        "mason-org/mason-lspconfig.nvim",
        event = { "CursorMoved", "CursorHold" }, --*
        opts = {},
    },
}
