vim.loader.enable() --高速読み込み

local opt = vim.opt
local vimg = vim.g
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
------------------------------------
-- 共通設定
------------------------------------
-- [プロバイダー関連]
vimg.loaded_perl_provider = 0    --perlプロバイダーを無効化
vimg.loaded_ruby_provider = 0    --rubyプロバイダーを無効化
vimg.loaded_python3_provider = 0 --pythonプロバイダーを無効化
vimg.loaded_node_provider = 0    --nodeプロバイダーを無効化

opt.clipboard = "unnamedplus"    --クリップボード連携 (デフォルト: "")
-- [インデントとタブ]
opt.tabstop = 4                  --タブ幅(8)
opt.shiftwidth = 4               --インデント幅(8)
opt.expandtab = true             --タブをスペースに変換
opt.smartindent = true           --自動インデント
-- opt.autoindent = true --自動インデント

-- [検索と置換]
opt.ignorecase = true --大文字・小文字を区別しない検索
opt.smartcase = true  --大文字を含む検索語のみ大文字・小文字を区別
opt.incsearch = true  --検索語入力中に検索結果をハイライト
opt.hlsearch = true   --検索にマッチした箇所をハイライト
opt.path:append("**") --findで再帰的にファイル検索

-- [バックアップ]
opt.undolevels = 5000 --取り消し可能な操作の数 (1000)
opt.swapfile = false  --スワップファイルを作成 (true)

-- [パフォーマンスと拡張性]
opt.updatetime = 500 --CursorHoldの起動時間

if not vimg.vscode then
    -----------------------------------
    -- neovimのみの設定
    -----------------------------------
    ---
    opt.winborder = "rounded"
    -- [ウィンドウ管理とタブページ]
    opt.splitbelow = true --新しいウィンドウを下に開く (false)
    opt.splitright = true --新しいウィンドウを右に開く (false)

    -- [表示設定]
    opt.number = true         --行番号表示
    opt.relativenumber = true --相対行番号で表示
    opt.cursorline = true     --カーソル行ハイライト
    -- opt.cursorcolumn = true --カーソル列ハイライト
    opt.termguicolors = true  --24bit カラー有効化
    opt.laststatus = 2        --ステータスラインの表示形式(1)
    opt.cmdheight = 0
    --[スクロール]
    opt.scrolloff = 15 --スクロールを開始するまでの行数 (0)

    --[折り返し]
    opt.linebreak = true --単語の途中で行を折り返さない (false)
    opt.wrap = false     --折り返し設定(true)

    --[括弧ジャンプ]
    opt.showmatch = true --対応する括弧にジャンプ
    opt.matchtime = 2    --対応する括弧のハイライト時間(5)

    -- [エンコーディング]
    opt.fileencoding = "utf-8" --保存時の文字エンコーディング
    opt.fileformat = "unix"    --ファイルの改行コード (unix/dos/mac)

    opt.hidden = true          --ファイルを閉じずにバッファを切り替え (false)
end
require("keymaps")
require("message")
require("lazy").setup({
    defaults = {
        lazy = true,
    },
    rocks = {
        enabled = false,
    },
    spec = {
        { import = "plugins.common" },
        {
            import = vimg.vscode and "plugins.vscode" or "plugins.neovim",
        },
    },
    local_spec = false, --ローカルplugin読み込み
    install = { colorscheme = vimg.vscode and {} or { "monokai" } },
    -- checker = { enabled = true, frequency = 86400 }, --更新のチェック
    performance = {
        cache = { enabled = true },
        reset_packpath = true,
    },
})
