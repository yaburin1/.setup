-- sudo dnf install fd-find
-- sudo dnf install ripgrep
return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		{
			"nvim-telescope/telescope-frecency.nvim",
			version = "*",
		},
	},
	cmd = { "Telescope" },
	keys = {
		{ "<leader>ff", mode = { "n" }, desc = "Find Files" },
		{ "<leader>fg", mode = { "n" }, desc = "Live grep" },
		{ "<leader>fb", mode = { "n" }, desc = "Buffers" },
		{ "<leader>f/", mode = { "n" }, desc = "Grep word" },
		{ "<leader>fr", mode = { "n" }, desc = "Resume" },
		{ "<leader>gc", mode = { "n" }, desc = "Commits" },
		{ "<leader>gs", mode = { "n" }, desc = "Status" },
		{ "<leader>gb", mode = { "n" }, desc = "Branches" },
		{ "grr", mode = { "n" }, desc = "References" },
		{ "gd", mode = { "n" }, desc = "Definitions" },
		{ "gO", mode = { "n" }, desc = "Symbols" },
	},
	opts = {
		defaults = {
			sorting_strategy = "ascending", --*descending(上から) ascending(下から)

			-- レイアウト: ピッカーのデフォルトレイアウト
			-- "horizontal": 左右分割（プレビューが右）
			-- "vertical": 上下分割（プレビューが上）
			-- "center": 中央配置（ドロップダウン風）
			-- "cursor": カーソル位置に表示
			-- "bottom_pane": 下部ペイン（ivy風）
			-- "flex": ウィンドウ幅に応じて horizontal/vertical を切り替え
			layout_strategy = "vertical", --horizontal

			-- レイアウト設定: 各戦略ごとのデフォルト値
			-- すべての戦略で共通設定も可能（トップレベルに記述）
			layout_config = {
				-- bottom_pane戦略（ivy風）
				bottom_pane = {
					height = 30, -- 固定高さ（24）
					preview_cutoff = 119, -- この列数未満でプレビュー無効(119)
					prompt_position = "top", -- プロンプト位置: ("top") | "bottom"
				},

				-- center戦略（ドロップダウン風）
				center = {
					height = 0.4, -- 画面の40%の高さ（0.4）
					preview_cutoff = 40, -- この行数未満でプレビュー無効(40)
					prompt_position = "top", --(top)
					width = 0.6, -- 画面の50%の幅（0.5）
				},

				-- cursor戦略（カーソル位置）
				cursor = {
					height = 0.25, -- 画面の90%の高さ(0.9)
					preview_cutoff = 40, -- この列数未満でプレビュー無効(40)
					width = 0.7, -- 画面の80%の幅(0.8)
				},

				-- horizontal戦略（水平分割）
				horizontal = {
					anchor = "N", -- ピッカーの位置: "CENTER", "N上", "NE", "E右", "SE", "S上", "SW", "W左", "NW"
					anchor_padding = 1, -- アンカー周辺のパディング
					height = 0.99, -- 画面の90%の高さ(0.9)
					preview_cutoff = 120, -- この列数未満でプレビュー無効(120)
					prompt_position = "top", --(bottom)
					width = { 0.99, max = 120 }, -- 画面の80%の幅(0.8)
					-- その他のオプション:
					-- mirror = false,        -- 結果とプレビューの位置を反転(false)
					preview_width = 0.7, -- プレビューの幅（0-1で割合、1以上で固定値）(0.5)
				},

				-- vertical戦略（垂直分割）
				vertical = {
					anchor = "N", -- ピッカーの位置: "CENTER", "N上", "NE", "E右", "SE", "S上", "SW", "W左", "NW"
					anchor_padding = 1, -- アンカー周辺のパディング
					height = 0.65, -- 画面の90%の高さ(0.9)
					preview_cutoff = 40, -- この行数未満でプレビュー無効(40)
					prompt_position = "top", --(bottom)
					width = { 0.99, max = 120 }, -- 画面の80%の幅(0.8)
					mirror = true, -- 結果とプレビューの位置を反転(false)
					-- preview_height = 0.5, -- プレビューの高さ（0-1で割合、1以上で固定値）(0.5)
				},

				-- 共通オプション
				-- anchor = "CENTER",           -- ピッカーの位置: "CENTER", "N上", "NE", "E右", "SE", "S上", "SW", "W左", "NW"
				-- anchor_padding = 0,          -- アンカー周辺のパディング
				-- scroll_speed = 1,            -- プレビューのスクロール速度（行数）
				-- 高さ/幅の詳細設定例:
				-- width = { 0.8 or 80, max = 100 ,min=50,padding=10}
				-- higtht = { 0.8 or 80, max = 100 ,min=50,padding=10}
			},

			-- レイアウト切り替えリスト
			-- actions.layout.cycle_layout_next/prev で切り替えるレイアウト
			cycle_layout_list = { "horizontal", "vertical" },

			-- ウィンドウの透明度（0-100）
			-- winblend = 5,

			prompt_prefix = "🔍 ", -- "> "
			selection_caret = "󰧂 ", -- "> "
			multi_icon = "󰄲 ", --"+"

			-- 初期モード: ピッカー起動時のモード
			-- initial_mode = "normal", --*insert or normal

			-- ボーダーを表示するか
			-- border = false, --*true

			-- ファイルパスの表示方法(配列または関数)
			-- path_display = {}, -- {}
			-- path_display = { "tail" },           -- ファイル名のみ表示
			-- path_display = { "absolute" },       -- 絶対パス表示
			-- path_display = { "smart" },          -- 差分のみ表示（スマート）
			-- path_display = { "shorten" },        -- ディレクトリ名を1文字に短縮
			-- path_display = { "truncate" }, -- 長いパスを先頭から切り詰め
			-- path_display = { "filename_first" }, -- ファイル名を先に表示
			-- path_display = { "hidden" }, -- ファイル名を非表示
			--
			-- 複数指定可能:
			-- path_display = { "truncate", "shorten" }
			--
			-- shorten のオプション:
			-- path_display = { shorten = 3 }              -- ディレクトリ名を3文字に短縮
			-- path_display = { shorten = { len = 2, exclude = {1, -1} } }  -- 最初と最後を除外
			--
			-- 関数の場合:
			-- path_display = function(opts, path)
			--   return formatted_path, highlights
			-- end

			results_title = false, --*"Results"
			prompt_title = false, --*"Prompt"

			mappings = {
				i = {
					["<c-j>"] = "move_selection_next",
					["<c-k>"] = "move_selection_previous",
					["<c-n>"] = "move_selection_next",
					["<c-p>"] = "move_selection_previous",
					["jj"] = { "<esc>", type = "command" },
					["<leader>fr"] = "close",
					["<leader>fg"] = "close",
					["<leader>fb"] = "close",
					["<leader>ff"] = "close",
				},
				n = {
					["q"] = "close",
					["<c-c>"] = "close",
					["<c-j>"] = "move_selection_next",
					["<c-k>"] = "move_selection_previous",
					["<c-n>"] = "move_selection_next",
					["<c-p>"] = "move_selection_previous",
					["<leader>fr"] = "close",
					["<leader>fg"] = "close",
					["<leader>fb"] = "close",
					["<leader>ff"] = "close",
				},
			},

			-- 履歴設定: プロンプトの入力履歴を管理
			-- false にすると履歴機能を無効化
			history = {
				-- 履歴ファイルの保存パス
				path = vim.fn.stdpath("data") .. "/telescope_history",
				limit = 100,
			},

			-- ピッカーキャッシュ設定
			-- キャッシュを使うには actions.resume を使用:
			-- vim.keymap.set('n', '<leader>tr', require('telescope.builtin').resume)

			-- vimgrep引数: live_grep と grep_string で使用するコマンド
			-- ripgrep (rg) のオプション
			vimgrep_arguments = {
				"rg", -- ripgrep コマンド
				"--color=never", -- カラー出力なし（必須）
				"--no-heading", -- ファイル名を各行に含める（必須）
				"--with-filename", -- ファイル名を表示（必須）
				"--line-number", -- 行番号を表示（必須）
				"--column", -- 列番号を表示（必須）
				"--smart-case", -- 大文字を含む場合は大文字小文字を区別
				-- (追加)
				"--glob=!.git/", -- .git ディレクトリを除外
				"--hidden", -- 隠しファイルも検索
			},

			-- lessを使用するか（非推奨、現在は使用されていない）
			use_less = false, --(true)

			-- 無視するファイルパターン（Lua正規表現）
			-- node_modules を無視すると LSP の結果も除外される可能性がある
			-- .gitignore を使い、fd/rg に認識させる方が良い
			file_ignore_patterns = { --*{}
				"%.git/.*", -- .git ディレクトリ
				"%.DS_Store", -- macOS の .DS_Store
			},
		},
		pickers = {
			find_files = {
				hidden = true, -- デフォルト: false
				-- cwd = nil, -- デフォルト: 現在のディレクトリ nil
				-- cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1], -- gitのルートディレクトリ
			},
			live_grep = {
				-- cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1], --nil
				additional_args = function() --nil
					return { "--hidden" }
				end,
				-- -- 行番号と列番号表示
				-- disable_coordinates = false, -- デフォルト: false
			},

			grep_string = {
				-- cwd = nil,
				use_regex = true, -- デフォルト: false（正規表現）
				-- word_match = nil, -- "-w" で完全一致
				additional_args = function()
					return { "--hidden" }
				end, -- nil
				-- -- 行番号と列番号表示
				-- disable_coordinates = false,
			},
			diagnostics = {
				-- severity = "error", -- デフォルト: nil

				-- この重要度以上
				-- severity_limit = "warning", -- デフォルト: nil

				-- 座標を非表示
				disable_coordinates = false, -- デフォルト: false

				-- ソート順
				sort_by = "buffer", -- デフォルト: "buffer"
				-- sort_by = "severity",
			},
			buffers = {
				-- 作業ディレクトリでフィルター
				cwd = nil, -- デフォルト: nil
			},
		},

		-- 拡張機能の設定
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
			frecency = {
				-- ignore_patterns = {},
				-- workspace = "CWD", --nil
				default_workspace = "CWD", --nil
				-- path_display = {},
				-- workspace_scan_cmd = nil,
			},
		},
	},

	config = function(_, opts)
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local keymap = vim.keymap.set
		telescope.setup(opts)
		telescope.load_extension("fzf")
		telescope.load_extension("frecency")

		keymap("n", "<leader>ff", function()
			telescope.extensions.frecency.frecency()
		end, { desc = "Find files frecency" })
		keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
		keymap("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
		keymap("n", "<leader>/", builtin.grep_string, { desc = "Grep word" })
		keymap("n", "<leader>fr", builtin.resume, { desc = "Resume" })

		keymap("n", "<leader>gc", builtin.git_commits, { desc = "Commits" })
		keymap("n", "<leader>gs", builtin.git_status, { desc = "Status" })
		keymap("n", "<leader>gb", builtin.git_branches, { desc = "Branches" })

		keymap("n", "grr", builtin.lsp_references, { desc = "References" })
		keymap("n", "gd", builtin.lsp_definitions, { desc = "Definitions" })
		keymap("n", "gO", builtin.lsp_document_symbols, { desc = "Symbols" })
	end,
}
