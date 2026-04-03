---@module "lazy"
---@type LazyPluginSpec
return {
	"wakatime/vim-wakatime",
	event = { "BufReadPre", "BufNewFile" },
}
