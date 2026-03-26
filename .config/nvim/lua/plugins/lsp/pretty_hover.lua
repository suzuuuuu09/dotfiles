---@module "lazy"
---@type LazyPluginSpec
return {
	"Fildo7525/pretty_hover",
	event = "LspAttach",
	config = true,
	keys = {
		{
			"K",
			function()
				require("pretty_hover").hover()
			end,
			desc = "Hover (Pretty Hover)",
			-- mode = { "n", "v" },
		},
	},
}
