return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	lazy = true,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvimtools/none-ls-extras.nvim" },
	},
	opts = function()
		local null_ls = require("null-ls")
		local b = null_ls.builtins

		return {
			sources = {
				-- ╭─────────────────────────────────────────────────────────╮
				-- │                        Formatter                        │
				-- ╰─────────────────────────────────────────────────────────╯
				b.formatting.stylua,   -- lua formatter
				-- b.formatting.black,    -- python formatter
				b.formatting.clang_format, -- c/c++ formatter
				-- b.formatting.beautysh, -- shell script formatter

				-- ╭─────────────────────────────────────────────────────────╮
				-- │                        Diagnostics                      │
				-- ╰─────────────────────────────────────────────────────────╯
				-- require("none-ls.diagnostics.ruff"), -- python linter
				require("none-ls.diagnostics.cpplint"), -- c/c++ linter

				-- ╭─────────────────────────────────────────────────────────╮
				-- │                      Code Actions                       │
				-- ╰─────────────────────────────────────────────────────────╯
				-- require("none-ls.code_actions.typos"), -- typo suggestions
			},
		}
	end,
}
