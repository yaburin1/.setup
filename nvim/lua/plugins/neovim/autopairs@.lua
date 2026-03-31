return {
	--[推奨]
	--treesitter
	"windwp/nvim-autopairs",
	event = "InsertEnter", --*
	opts = {
		map_c_h = true, --false
		map_c_w = true, --false

		fast_wrap = {
			-- map="<M-e>" --enclose
		},
		check_ts = true, --(false)
		ts_config = {
			-- lua        =  {'string', 'source', 'string_content' }, --defalt
			-- javascript = { 'string', 'template_string' }, --defalt
			typescript = { "string", "template_string" },
			tsx = { "string", "template_string", "jsx_text" },
			python = { "string" },
			go = { "interpreted_string_literal", "raw_string_literal" },
			rust = { "string_literal", "raw_string_literal" },
			java = { "string_literal" },
			c = { "string_literal" },
			cpp = { "string_literal", "raw_string_literal" },
			sh = { "string", "raw_string" },
			html = { "attribute_value" },
			css = { "string" },
			json = { "string" },
			toml = { "string", "ml_basic_string", "ml_literal_string" },
			yaml = { "string_scalar", "block_scalar" },
			markdown = { "inline_code", "fenced_code_block" },
			vim = { "string" },
			sql = { "string_literal" },
		},
	},
	config = function(_, opts)
		local npairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")
		npairs.setup(opts)
		-- htmldjango
		npairs.add_rule(Rule("{{ ", " }}", "htmldjango"):with_pair(cond.not_after_regex("}")):with_move(cond.done()))
		-- {% の後に既存の %} がある行ではスキップ
		npairs.add_rule(Rule("{% ", " %}", "htmldjango"):with_pair(cond.not_after_regex("%%}")))
		-- {# #} コメント
		Rule("{# ", " #}", "htmldjango"):with_pair(cond.not_after_regex("#}"))
	end,
}
