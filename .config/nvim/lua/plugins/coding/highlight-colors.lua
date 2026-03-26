return {
	"brenoprata10/nvim-highlight-colors",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		enable_named_colors = false,
		render = "virtual",
		virtual_symbol = "󱓻",
		enable_hex = true,
		enable_short_hex = true,
		enable_rgb = true,
		enable_hsl = true,
		enable_hsl_without_function = true,
		enable_ansi = true,
		enable_var_usage = true,
		enable_tailwind = true,
	},
	keys = {
		{ "<leader>Ct", "<CMD>HighlightColors Toggle<CR>", desc = "Toggle highlight colors" },
	},
}

-- text-red-500
-- #ff41d1
