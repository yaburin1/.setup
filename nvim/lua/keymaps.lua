local vimg = vim.g
local vimf = vim.fn
local keymap = vim.keymap.set
local opts = { silent = true }
--------------------
-- 共通キーマップ --
--------------------

-- リーダーキー
vimg.mapleader = " "

-- Yで行末までヤンク
keymap("n", "Y", "y$", opts)

-- visualでペースト時にレジスタを汚さない
keymap("x", "p", "P", opts)

-- sentence (文)
keymap({ "x", "o" }, "iS", "is")
keymap({ "x", "o" }, "aS", "as")
-- インデントを揃えてペースト
keymap({ "n", "x", "o" }, "=p", "]p")
keymap({ "n", "x", "o" }, "=P", "[p")
-- 引数リスト移動
keymap({ "n", "x", "o" }, "ga", "]a")
keymap({ "n", "x", "o" }, "gA", "[a")
-- スペルチェック
keymap({ "n", "x", "o" }, "gs", "]s")
keymap({ "n", "x", "o" }, "gS", "[s")

-- インデントを揃えて挿入
keymap("n", "i", function()
    if vimf.empty(vimf.getline(".")) == 1 then
        return '"_cc'
    else
        return "i"
    end
end, { expr = true })

keymap("n", "A", function()
    if vimf.empty(vimf.getline(".")) == 1 then
        return '"_cc'
    else
        return "A"
    end
end, { expr = true })

-- %%で現在ファイルのディレクトリパスを入力(%:hと同じ)
keymap("c", "%%", function()
    if vimf.getcmdtype() == ":" then
        return vimf.expand("%:h") .. "/"
    else
        return "%%"
    end
end, { expr = true })

if vimg.vscode then
    -----------------------
    -- vscodeキーマップ  --
    -----------------------
    local vscode = require("vscode")
    local action = vscode.action

    keymap({ "n" }, "<leader>af", function()
        action("editor.action.formatDocument")
    end)
    keymap({ "n" }, "<leader>ff", function()
        action("workbench.action.quickOpen")
    end)
    keymap({ "n" }, "<leader>e", function()
        action("workbench.view.explorer")
    end)
    keymap({ "n" }, "<leader>q", function()
        action("workbench.action.closeActiveEditor")
    end)
    keymap({ "n" }, "<leader>z", function()
        action("workbench.action.toggleZenMode")
    end)
else
    ----------------------
    -- neovimキーマップ --
    ----------------------
    keymap({ "i" }, "jk", "<ESC>", opts)
    keymap({ "n" }, "<C-n>", function()
        vim.cmd.bnext()
    end, opts)
    keymap({ "n" }, "<C-p>", function()
        vim.cmd.bprevious()
    end, opts)
    keymap({ "n" }, "<C-Tab>", function()
        vim.cmd.bnext()
    end, opts)
    keymap({ "n" }, "<C-S-Tab>", function()
        vim.cmd.bprevious()
    end, opts)
    -- <Esc><Esc>でターミナルでnormal移行
    keymap("t", "<Esc><Esc>", [[<C-\><C-n>]], opts)

    -- keymap("n", "[j", "<C-o>", opts)
    -- keymap("n", "]j", "<Tab>", opts)
    -- keymap("n", "<Tab>", "<cmd>bnext<cr>", opts)
    -- keymap("n", "<S-Tab>", "<cmd>bprevious<cr>", opts)
end
