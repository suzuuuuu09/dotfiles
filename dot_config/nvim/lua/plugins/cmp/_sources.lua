local M = {
	dir = vim.fn.stdpath("config"),
	enabled = false,
}

---@module "blink.cmp"
---@type blink.cmp.SourceConfigPartial
M.sources = {
	default = {
		"snippets",
		"lazydev",
		"lsp",
		"path",
		"buffer",
	},
	providers = {
		lazydev = {
			name = "LazyDev",
			module = "lazydev.integrations.blink",
			score_offset = 100,
		},
		snippets = { score_offset = 1 },
	},
}

return M
