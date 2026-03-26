---@module "lazy"
---@type LazyPluginSpec
return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	enabled = false,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("ts_context_commentstring").setup({
			enable_autocmd = false,
		})
	end,
}
