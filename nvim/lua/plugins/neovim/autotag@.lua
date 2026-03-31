return {
	--[必須]
	-- treesitter
	"windwp/nvim-ts-autotag",
	event = "InsertEnter", --*
	-- event = { "BufReadPre", "BufNewFile" },--推奨
	opts = {},
}
