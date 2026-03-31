return {
	"chentoast/marks.nvim",
	event = { "CursorMoved" },
	keys = {
		{ "m", mode = { "n" } },
		{ "dm", mode = { "n" } },
		{ "[m", mode = { "n" } },
		{ "]m", mode = { "n" } },
		{ "{m", mode = { "n" } },
		{ "{m", mode = { "n" } },
	},
	opts = {
		builtin_marks = { "`", "." },
		-- builtin_marks = { ".", "<", ">", "^" },
		excluded_filetypes = { "help", "dashboard" },
		excluded_buftypes = { "terminal", "nofile" },

		-- ブックマーク
		bookmark_0 = {
			sign = "⚑",
			virt_text = "TODO",
			-- annotate = true, -- テキストを自由入力
		},

		mappings = {
			next = "]m",
			prev = "[m",
			next_bookmark = "]M",
			prev_bookmark = "[M",
		},
	},
	config = function(_, opts)
		require("marks").setup(opts)
		local set_hl = vim.api.nvim_set_hl
		set_hl(0, "MarkSignHL", { fg = "#CCFF00" })
		set_hl(0, "MarkSignNumHL", { fg = "#CCFF00" })
		set_hl(0, "MarkVirtTextHL", { fg = "#CCFF00" })
	end,
}

-- mx              Set mark x
-- m,              Set the next available alphabetical (lowercase) mark
-- m;              Toggle the next available mark at the current line
-- dmx             Delete mark x
-- dm-             Delete all marks on the current line
-- dm<space>       Delete all marks in the current buffer
-- m]              Move to next mark
-- m[              Move to previous mark
-- m:              Preview mark. This will prompt you for a specific mark to
--                 preview; press <cr> to preview the next mark.
--
-- m[0-9]          Add a bookmark from bookmark group[0-9].
-- dm[0-9]         Delete all bookmarks from bookmark group[0-9].
-- m}              Move to the next bookmark having the same type as the bookmark under
--                 the cursor. Works across buffers.
-- m{              Move to the previous bookmark having the same type as the bookmark under
--                 the cursor. Works across buffers.
-- dm=             Delete the bookmark under the cursor.
