return {
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = true,
			},
			trace = {
				server = "off",
			},
			cargo = {
				allFeatures = true,
			},
			procMacro = {
				enable = true,
			},
			checkOnSave = {
				command = "clippy",
			},
		},
	},
}
