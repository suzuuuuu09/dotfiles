local extend_js = {
	"typescript",
	"typescriptreact",
	"javascriptreact",
	"astro",
	"svelte",
	"vue",
}

---@module "lazy"
---@type LazyPluginSpec
return {
	"L3MON4D3/LuaSnip",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = { "rafamadriz/friendly-snippets" },
	build = "make install_jsregexp",
	version = "v2.*",
	config = function()
		local ls = require("luasnip")
		---@module "luasnip"
		---@type LuaSnip.Loaders.LoadOpts
		require("luasnip.loaders.from_lua").load({
			paths = { "~/.config/nvim/snippet" },
			override_priority = 2000,
		})

		for _, lang in ipairs(extend_js) do
			ls.filetype_extend(lang, { "javascript" })
		end
	end,
}
