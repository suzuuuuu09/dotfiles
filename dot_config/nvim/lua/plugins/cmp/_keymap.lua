local M = {
	dir = vim.fn.stdpath("config"),
	enabled = false,
}

---@module "blink.cmp"
---@type blink.cmp.KeymapConfig
M.keymap = {
	["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
	["<Up>"] = { "select_prev", "fallback" },
	["<Down>"] = { "select_next", "fallback" },
	["<C-N>"] = { "select_next", "show" },
	["<C-P>"] = { "select_prev", "show" },
	["<C-J>"] = { "select_next", "fallback" },
	["<C-K>"] = { "select_prev", "fallback" },
	["<C-U>"] = { "scroll_documentation_up", "fallback" },
	["<C-D>"] = { "scroll_documentation_down", "fallback" },
	["<C-e>"] = { "hide", "fallback" },
	["<CR>"] = { "accept", "fallback" },
	["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
	["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
}

return M
