--[必要]
-- @ tree-sitter-cli
-- cargo install --locked tree-sitter-cli
return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" }, --*
        build = ":TSUpdate",
        config = function()
            local v = vim
            local api = v.api
            -- require("nvim-treesitter").install({ "lua" })
            api.nvim_create_autocmd("FileType", {
                group = api.nvim_create_augroup("nvim_treesitter_start", {}),
                callback = function(args)
                    pcall(v.treesitter.start, args.buf)
                    -- v.wo[0][0].foldmethod = "expr"
                    -- v.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    v.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        opts = {
            selection_modes = {
                ["@function.outer"] = "V",
                ["@class.outer"] = "V",
                ["@block.outer"] = "V",
                ["@conditional.outer"] = "V",
                ["@loop.outer"] = "V",
                ["@statement.outer"] = "V",
            },
        },
        config = function(_, opts)
            vim.g.no_plugin_maps = true
            require("nvim-treesitter-textobjects").setup(opts)
        end,
        keys = {
            {
                "af",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "関数(外側)",
            },
            {
                "if",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "関数(内側)",
            },
            {
                "ac",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "クラス(外側)",
            },
            {
                "ic",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "クラス(内側)",
            },
            {
                "aa",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "引数(外側)",
            },
            {
                "ia",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "引数(内側)",
            },
            {
                "ab",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "ブロック(外側)",
            },
            {
                "ib",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "ブロック(内側)",
            },
            {
                "ai",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@conditional.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "条件文(外側)",
            },
            {
                "ii",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@conditional.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "条件文(内側)",
            },
            {
                "al",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@loop.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "ループ(外側)",
            },
            {
                "il",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@loop.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "ループ(内側)",
            },
            {
                "a=",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@assignment.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "代入文(外側)",
            },
            {
                "i=",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@assignment.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "代入文(内側)",
            },
            {
                "a/",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "コメント(外側)",
            },
            {
                "i/",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@comment.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "コメント(内側)",
            },
            {
                "as",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@statement.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "文(外側)",
            },
            {
                "is",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@statement.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "文(内側)",
            },
            {
                "aB",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
                end,
                mode = { "x", "o" },
                desc = "スコープ(外側)",
            },
            {
                "iB",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
                end,
                mode = { "x", "o" },
                desc = "スコープ(内側)",
            },
            {
                "]f",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "次の関数へ",
            },
            {
                "[f",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "前の関数へ",
            },
            {
                "]]",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "次のクラスへ",
            },
            {
                "[[",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "前のクラスへ",
            },
            {
                "]i",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "次の条件文へ",
            },
            {
                "[i",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "前の条件文へ",
            },
            {
                "]/",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@comment.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "次のコメントへ",
            },
            {
                "[/",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@comment.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "前のコメントへ",
            },
            {
                "]a",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "次の引数へ",
            },
            {
                "[a",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "前の引数へ",
            },
            {
                "]=",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@assignment.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "次の代入文へ",
            },
            {
                "[=",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@assignment.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "前の代入文へ",
            },
            {
                "]p",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@loop.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "次のループへ",
            },
            {
                "[p",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@loop.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "前のループへ",
            },
            {
                "]s",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@statement.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "次の文へ",
            },
            {
                "[s",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@statement.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "前の文へ",
            },
            {
                "<leader>aa",
                mode = "n",
                function()
                    require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
                end,
                desc = "引数を次と入れ替え",
            },
            {
                "<leader>AA",
                function()
                    require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
                end,
                mode = "n",
                desc = "引数を前と入れ替え",
            },
        },
    },
}
