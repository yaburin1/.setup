--[オプション]
--vscode-dev-icon
return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = { "CmdlineChanged" },
	keys = {
		{
			"<leader>e",
			function()
				require("oil").toggle_float()
			end,
			mode = "n",
			desc = "Oil Open",
		},
	},
	opts = {
		skip_confirm_for_simple_edits = true, --false
		watch_for_changes = true, --false
		columns = {
			"icon",
		},
		buf_options = {
			buflisted = true, --false
			-- bufhidden = "hide",
		},
		lsp_file_methods = {
			autosave_changes = "unmodified",
		},
		keymaps = {
			["gd"] = {
				desc = "Toggle file detail view",
				callback = function()
					detail = not detail
					if detail then
						require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
					else
						require("oil").set_columns({ "icon" })
					end
				end,
			},
		},
		view_options = {
			show_hidden = true, --false
		},
		preview_win = {
			disable_preview = function(filename)
				-- バイナリファイルを無効化
				local ext = vim.fn.fnamemodify(filename, ":e")
				if vim.tbl_contains({ "jpg", "png", "gif", "pdf", "zip" }, ext) then
					return true
				end
				return false
			end,
		},
	},
}
