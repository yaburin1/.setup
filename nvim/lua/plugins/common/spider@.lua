return {
	"chrisgrieser/nvim-spider",
	keys = {
		{
			"w",
			function()
				require("spider").motion("w")
			end,
			mode = { "n", "o", "x" },
			desc = "Spider Motion w",
		},
		{
			"e",
			function()
				require("spider").motion("e")
			end,
			mode = { "n", "o", "x" },
			desc = "Spider Motion e",
		},
		{
			"b",
			function()
				require("spider").motion("b")
			end,
			mode = { "n", "o", "x" },
			desc = "Spider Motion b",
		},
		{
			"ge",
			function()
				require("spider").motion("ge")
			end,
			mode = { "n", "o", "x" },
			desc = "Spider Motion e",
		},
	},
	opts = {
		consistentOperatorPending = true, --dwとかも上書き
	},
}
