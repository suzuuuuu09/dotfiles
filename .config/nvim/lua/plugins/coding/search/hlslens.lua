---@module "lazy"
---@type LazyPluginSpec
return {
	"kevinhwang91/nvim-hlslens",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		
	},
	config = function(_, opts)
		require("hlslens").setup(opts)
	end,
}
