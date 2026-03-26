local p = require("nord.colors").palette

--- @module "lazy"
---@type LazyPluginSpec
return {
	"shellRaining/hlchunk.nvim",
	event = "UIEnter",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	---@module "hlchunk"
	opts = {
		chunk = {
			enable = true,
			use_treesitter = true,
			style = p.frost.polar_water,
		},
		indent = {
			enable = true,
			chars = { "│", "¦", "┆", "┊" },
		},
		blank = {
			enable = false,
		},
	},
}
