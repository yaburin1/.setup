return {

	"brenoprata10/nvim-highlight-colors",
	event = { "CursorMoved", "CursorHold" },
	opts = {
		---@usage 'background'|'foreground'|'virtual'
		render = "virtual",
		enable_tailwind = true,
	},
}
