return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach", --*
	opts = {
		preset = "classic",
		-- transparent_bg = true, --背景透明化(false)
		options = {
			show_source = {
				enabled = true, --false
				if_many = true, --複数行のときだけ表示(false)
			},
			show_code = false, --エラー番号(true)
			softwrap = 40, --30
			add_messages = {
				show_multiple_glyphs = false, -- icon重複
			},
			multilines = {
				enabled = true, --fasle
				always_show = true, --false
				severity = { vim.diagnostic.severity.ERROR },
			},

			-- format = function(diag)
			-- 	return "[" .. diag.code .. "] " .. diag.message
			-- -- diag.message	エラーメッセージ
			-- -- diag.source	LSP名
			-- -- diag.code	エラーコード
			-- -- diag.severity	エラーの種類
			-- end,

			--表示する警告
			-- severity = {
			-- 	vim.diagnostic.severity.ERROR,
			-- 	vim.diagnostic.severity.WARN,
			-- 	vim.diagnostic.severity.INFO,
			-- 	vim.diagnostic.severity.HINT,
			-- },
		},
	},
	config = function(_, opts)
		vim.diagnostic.config({ virtual_text = false })
		require("tiny-inline-diagnostic").setup(opts)
	end,
}
