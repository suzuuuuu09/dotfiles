---@module "lazy"
---@type LazyPluginSpec
return {
	"danymat/neogen",
	cmd = "Neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	---@module "neogen"
	opts = {
		enabled = true,
		snippet_engine = "luasnip",
		-- 生成後に自動的に挿入モードに入り、最初のTODO箇所にジャンプする
		input_after_comment = true,

		-- ここで「TODO」を流し込む設定をする
		placeholders_text = {
			["description"] = "TODO: Description",
			["parameter"] = "TODO: Parameter",
			["type"] = "TODO: Type",
			["return"] = "TODO: Return",
		},
	},
}
