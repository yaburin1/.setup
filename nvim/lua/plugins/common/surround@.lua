return {
	--[推奨]
	--nvim-treesitter-textobjects
	"kylechui/nvim-surround",
	version = "*",
	keys = {
		{ "ys", mode = { "n" } },
		{ "ds", mode = { "n" } },
		{ "cs", mode = { "n" } },
	},
	opts = {
		highlight = {
			duration = 1000,
		},
	},
}
