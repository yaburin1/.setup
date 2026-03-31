return {
	"saghen/blink.cmp",
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		{ "onsails/lspkind.nvim" },
		{ "brenoprata10/nvim-highlight-colors" },
		{
			"kawre/neotab.nvim",
			-- event = { "InsertEnter" },
			opts = {
				tabkey = "",
				reverse_key = "",
				act_as_tab = true,
				pairs = {
					{ open = "(", close = ")" },
					{ open = "[", close = "]" },
					{ open = "{", close = "}" },
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = "`", close = "`" },
					{ open = "<", close = ">" },
					{ open = "%", close = "%" },
				},
				smart_punctuators = {
					enabled = true,
					semicolon = {
						enabled = true,
						ft = { "cs", "c", "cpp", "java" },
					},
				},
			},
		},
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				local api = vim.api
				api.nvim_create_autocmd({ "CmdlineEnter", "CursorHold" }, {
					group = api.nvim_create_augroup("luasnip", {}),
					pattern = "*",
					callback = function()
						local luasnip = require("luasnip")
						local bufnr = api.nvim_get_current_buf()
						if luasnip.session.current_nodes[bufnr] then
							luasnip.unlink_current()
						end
					end,
				})
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
	},
	opts = {
		snippets = { preset = "luasnip" },
		keymap = {
			-- 'default','super-tab','enter','none'
			preset = "none",

			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },

			["<C-e>"] = { "hide", "fallback" },
			["<C-y>"] = { "select_and_accept", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },

			["<CR>"] = { "accept", "fallback" },
			["<C-n>"] = {
				function(cmp)
					cmp.select_next({ on_ghost_text = true })
					return true
				end,
				"fallback_to_mappings",
			},

			["<C-p>"] = {
				function(cmp)
					cmp.select_prev({ on_ghost_text = true })
					return true
				end,
				"fallback_to_mappings",
			},
			["<Tab>"] = {
				"select_next",
				function(cmp)
					if cmp.snippet_active({ direction = 1 }) then
						return nil
					end
					local api = vim.api
					local mode = api.nvim_get_mode().mode
					if mode ~= "s" and mode ~= "S" and mode ~= "\19" then
						return nil
					end
					local cursor_line = api.nvim_win_get_cursor(0)[1]
					local visual_line = vim.fn.line("v")
					if cursor_line == visual_line then
						return nil
					end
					api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>`>a", true, false, true), "n", true)
					require("luasnip").unlink_current()
					return true
				end,
				function()
					vim.schedule(function()
						require("neotab").tabout_luasnip()
					end)
					return true
				end,
			},
			["<S-Tab>"] = {
				"select_prev",
				"snippet_backward",
				function()
					vim.schedule(function()
						require("neotab").tabreverse()
					end)
					return true
				end,
			},
		},
		completion = {
			keyword = {
				range = "full", --補完提案の範囲(prefix)
			},
			--  --起動設定
			trigger = {
				-- show_on_backspace = true,            --バックスペース(false)
				show_on_backspace_in_keyword = true, --キーワード&バックスペース(false)
				show_on_backspace_after_accept = false, --補完確定&バックスペース(true)
				show_on_backspace_after_insert_enter = false, --inset&バックスペース(true)
				-- show_on_keyword = false,--文字入力時(true)
				-- show_on_trigger_character = false,--lspトリガー文字(true)
				-- show_on_insert = true, --insertに入った瞬間(false)
				-- show_on_blocked_trigger_characters = { ' ', '\n', '\t' }, --この文字を入力した瞬間は補完を出さない{ ' ', '\n', '\t' }
				-- show_on_accept_on_trigger_character = false,--補完完了後(true)
				show_on_insert_on_trigger_character = false, --insert(true)
				-- show_on_x_blocked_trigger_characters = { "'", '"', '(' }, --その文字の後では補完を出さない{ "'", '"', '(' }
			},

			list = {
				-- max_items = 200, --表示する最大アイテム数
				selection = {
					preselect = false, --自動で最初を選択(true)
					auto_insert = false, --自動挿入(true)
				},
			},

			--ウィンドウ設定
			menu = {
				-- enabled = false,    --有効化(true)
				scrollbar = false, --スクロールバー(true)

				-- auto_show = false, --自動でメニュー表示(true)

				--補完メニュー非表示(スペニット可能、"))
				auto_show = function()
					local cmp = require("blink.cmp")
					local snippet_active = cmp.snippet_active
					local blocked_pattern = "[%(%[%{%)}%]%\"'`<>]"
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local line = vim.api.nvim_get_current_line()
					local char_after = line:sub(col + 1, col + 1)

					if char_after:match(blocked_pattern) then
						return false
					end

					return not (snippet_active({ direction = 1 }) or snippet_active({ direction = -1 }))
				end, --ゴーストテキストを避けてメニュー表示
				direction_priority = function()
					local ctx = require("blink.cmp").get_context()
					local item = require("blink.cmp").get_selected_item()
					if ctx == nil or item == nil then
						return { "s", "n" }
					end

					local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
					local is_multi_line = item_text:find("\n") ~= nil
					if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
						vim.g.blink_cmp_upwards_ctx_id = ctx.id
						return { "n", "s" }
					end
					return { "s", "n" }
				end,

				draw = {
					-- padding = { 1,0 },          --メニューの左右パディング(1)
					-- gap = 2,                     --カラム間のスペース(1)
					treesitter = { "lsp" }, --treesitterでハイライトするソース({})
					--メニュー表示レイアウト
					-- columns = { { "source_name" }, { "label", "label_description" }, { "kind_icon", gap = 1 } },
					--({ { 'kind_icon' }, { 'label', 'label_description', gap = 1 } }),

					--部品ごとの表示設定
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = ctx.kind_icon

								-- Path sourceの場合: nvim-web-deviconsを使用
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
									-- LSP sourceの場合: nvim-highlight-colorsで色情報をチェック
								elseif ctx.item.source_name == "LSP" then
									local color_item = require("nvim-highlight-colors").format(
										ctx.item.documentation,
										{ kind = ctx.kind }
									)
									if color_item and color_item.abbr ~= "" then
										icon = color_item.abbr
									end
									-- その他のsource: lspkindを使用
								else
									local lspkind = require("lspkind")
									lspkind.init({
										preset = "codicons",
									})
									icon = lspkind.symbol_map[ctx.kind] or ""
								end

								return icon .. ctx.icon_gap
							end,

							highlight = function(ctx)
								local hl = ctx.kind_hl

								-- Path sourceの場合: nvim-web-deviconsのハイライトを使用
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
									-- LSP sourceの場合: nvim-highlight-colorsのハイライトグループを使用
								elseif ctx.item.source_name == "LSP" then
									local color_item = require("nvim-highlight-colors").format(
										ctx.item.documentation,
										{ kind = ctx.kind }
									)
									if color_item and color_item.abbr_hl_group then
										hl = color_item.abbr_hl_group
									end
								end

								return hl
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true, --自動表示(false)
				-- auto_show_delay_ms = 500, --遅延(500)
				-- window = {
				-- min_width = 10,--(10)
				-- max_width = 80,--(80)
				-- max_height = 20,--(20)
				-- winblend = 0,--透明度(0)
				-- scrollbar = false,--(true)
				-- },
			},
			ghost_text = {
				enabled = true, --有効(false)
				-- show_with_selection = false,--アイテムが選択されている時(true)
				show_without_selection = true, --アイテムが未選択の時(false)
				-- show_with_menu = false,--メニューが開いてる時(true)
				-- show_without_menu = false, --メニューが閉じてる時(true)
			},
		},
		-- シグネチャ
		signature = {
			enabled = true, --有効(false)
			--トリガー
			-- trigger = {
			--     enabled = false, --自動表示(true)
			-- show_on_keyword = true, --入力時に表示(fasle)
			--     blocked_trigger_characters = {}, --除外文字{}
			--     blocked_retrigger_characters = {}, --再トリガー除外文字{}
			--     show_on_trigger_character = false, --LSPのトリガー文字((,.)入力時に表示(true)
			-- show_on_insert = true, --insert開始時に表示(false)
			--     show_on_insert_on_trigger_character = false, --insertでトリガー文字なら(true)
			-- },

			-- window = {
			-- min_width = 1,      --(1)
			-- max_width = 100,    --(100)
			-- max_height = 10,    --(10)
			-- border = 'rounded', -- Defaults to `vim.o.winborder` (nil)
			-- winblend = 0,       --透明度
			-- scrollbar = true, --(false)
			-- direction_priority = { 'n', 's' },
			--
			-- treesitter_highlighting = false, --(true)
			-- show_documentation = false,      --(true)
			-- },
		},

		fuzzy = {
			--許容するタイプミスの数
			-- max_typos = function(keyword) return math.floor(#keyword / 4) end,
			-- max_typos = function(keyword) return math.floor(#keyword / 4) end,

			-- ソートの優先順位
			sorts = {
				"exact", --完全一致
				"score", --マッチスコア
				"sort_text", --LSPsorttxt
			},
		},

		sources = {
			--defaultソース
			-- -- default = { 'lsp', 'path', 'snippets', 'buffer' },
			default = function(ctx)
				local success, node = pcall(vim.treesitter.get_node)
				--コメントではbuffuerのみ
				if
					success
					and node
					and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
				then
					return { "buffer" }
					-- elseif vim.bo.filetype == 'lua' then
					--     return { 'lsp', 'path' }
				else
					return { "lsp", "path", "snippets", "buffer" }
				end
			end,

			-- filetypeごとにソースを設定
			-- per_filetype = {
			--     -- optionally inherit from the `default` sources
			--     -- lua = { inherit_defaults = true, 'lsp', 'path' },
			--     -- vim = { inherit_defaults = true, 'cmdline' },
			-- },

			-- min_keyword_length = 0, --トリガーに必要なワードの長さ(0)

			--各補完ソースごとの設定
			providers = {
				lsp = {
					--LSPのキーワード(if,for)を補完候補から除外( transform_items = nil)
					transform_items = function(_, items)
						local kinds = require("blink.cmp.types").CompletionItemKind
						return vim.tbl_filter(function(item)
							-- Keyword か Snippet なら除外
							return item.kind ~= kinds.Keyword and item.kind ~= kinds.Snippet
						end, items)
					end,
					-- max_items = nil,        --(nil)
					-- min_keyword_length = 0, --(0)
					-- fallbacks = {},         --0件のときに表示するソース{}
					--score_offset = 0, --アイテムのスコアを加算(0)
				},
				cmdline = {
					enabled = function()
						return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
					end,
				},

				-- path = {
				-- score_offset = 3,--スコア加算(3)
				-- fallbacks = { 'buffer' },
				-- opts = {
				--     --補完開始起点(バッファのディレクトリ)
				--     get_cwd = function(context) return vim.fn.expand(('#%d:p:h'):format(context.bufnr)) end,
				--     -- get_cwd = function(context) return vim.fn.expand(('#%d:p:h'):format(context.bufnr)) end,
				--
				--     show_hidden_files_by_default = true,--隠しファイルの表示(false)
				--     ignore_root_slash = true, -- /pathをシステムルートじゃなくcwdとして扱う(false)
				--     -- Maximum number of files/directories to return. This limits memory use and responsiveness for very large folders.
				--     max_entries = 10000,--最大数(10000)
				-- },
				-- },
				snippets = {
					--.や"の後にスピニット候補を表示しない
					should_show_items = function(ctx)
						return ctx.trigger.initial_kind ~= "trigger_character"
					end,
					--     score_offset = -1, -- (-1)
					--
					--     -- For `snippets.preset == 'luasnip'`
					--     -- opts = {
					--     --     use_show_condition = false,--(true)
					--     --     show_autosnippets = false,--(ture)
					--     --     prefer_doc_trig = true,--(false)
					--     --     use_label_description = true,--(fasle)
					--     -- }
					--
				},
			},
		},
		appearance = {
			-- カラースキームが対応してない場合
			use_nvim_cmp_as_default = true, --false
			-- nerd_fontの種類
			nerd_font_variant = "normal", --'mono'
		},
		cmdline = {
			sources = function()
				local type = vim.fn.getcmdtype()
				if type == "/" or type == "?" then
					return { "buffer" }
				end
				if type == ":" or type == "@" then
					return { "cmdline", "buffer" }
				end
				return {}
			end,
			keymap = {
				-- preset = 'cmdline'
				["<C-n>"] = { "show_and_insert_or_accept_single", "select_next", "fallback" },
			},
			completion = {
				list = {
					selection = {
						preselect = false, --(true)
						-- auto_insert = false,--(true)
					},
				},
				ghost_text = {
					enabled = false, --(true)
				},
			},
		},
	},

	config = function(_, opts)
		require("blink.cmp").setup(opts)
		--ゴーストテキストのハイライト変更
		vim.api.nvim_set_hl(0, "BlinkCmpGhostText", {
			link = "Comment",
		})
	end,
	opts_extend = { "sources.default" },
}
