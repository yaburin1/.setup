return {
	"folke/flash.nvim",
	event = { "CursorMoved" },
	dependencies = {
		{
			"mawkler/demicolon.nvim",
			opts = {
				horizontal_motions = false,
				disabled_keys = { "I", "A" },
			},
		},
		{ "anuvyklack/keymap-amend.nvim" },
		{
			"jinh0/eyeliner.nvim",
			opts = {
				highlight_on_key = true,
				dim = true,
				default_keymaps = false,
			},
		},
	},
	opts = {
		modes = {
			search = {
				-- enabled = true, --false
				label = {
					before = true, --false
					after = false, --true
					style = "inline", --overlay
					format = function(opts)
						return { { string.format("[%s]", opts.match.label), opts.hl_group } }
					end,
				},

				highlight = {
					backdrop = true, --fasle
				},
			},
			char = {
				label = {
					exclude = "svyxhjkliardc",
					format = function(opts)
						return { { string.format("[%s]", opts.match.label), opts.hl_group } }
					end,
				},

				highlight = {
					matches = false, --true
					priority = 4096, --5000
				},
				jump_labels = true, --false
			},
			treesitter = {
				highlight = {
					backdrop = true, --false
					groups = {
						label = "FlashLabelTreesitter",
					},
				},
			},
		},
		remote_op = {
			restore = true, --false
			motion = true, --false
		},
	},
	config = function(_, opts)
		require("flash").setup(opts)
		local amend = require("keymap-amend")
		local eyeliner = require("eyeliner")

		for key, forward in pairs({ f = true, F = false, t = true, T = false }) do
			amend({ "n", "o", "x" }, key, function(original)
				eyeliner.highlight({ forward = forward })
				original()
			end)
		end
		local set_hl = vim.api.nvim_set_hl
		set_hl(0, "FlashMatch", { fg = "#00FFFF" })
		set_hl(0, "FlashLabel", { fg = "#FF0099", bold = true, italic = true })
		set_hl(0, "FlashCurrent", { fg = "#00FFFF" })

		set_hl(0, "FlashLabelTreesitter", { fg = "#00FF66", bold = true, underline = true })

		set_hl(0, "EyelinerPrimary", { fg = "#00FF66", underline = true })
		set_hl(0, "EyelinerSecondary", { fg = "#FF0099", underline = true })
	end,
	keys = {
		{
			"<CR>",
			mode = { "n", "x", "o" },
			function()
				local bufname = vim.api.nvim_buf_get_name(0)
				if bufname == "" then
					return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
				end
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"<leader><CR>",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
		{
			"<c-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
}
