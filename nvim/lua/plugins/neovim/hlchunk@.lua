return {
	--[推奨]
	--treesitter
	"shellRaining/hlchunk.nvim",
	event = { "CursorMoved" },
	opts = {
		chunk = {
			enable = true,
			style = { { fg = "#f92657" }, { fg = "#f8f8f0" } },
			-- use_treesitter = true,--true
			-- duration = 200,-- (200)
			delay = 150, --(300)
		},
	},
}
-- 推奨設定
-- event = { "BufReadPre", "BufNewFile" }
