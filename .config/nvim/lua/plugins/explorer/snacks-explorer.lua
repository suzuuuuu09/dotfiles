---@module "lazy"
---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	---@module "snacks"
	---@type snacks.Config
	opts = {
		picker = {
			sources = {
				explorer = {
					layout = {
						layout = {
							width = 30,
						}
					}
				}
			}
		}
	},
	keys = {
		{ "<leader>e", function () require("snacks.explorer").open() end, desc = "Open Snacks Explorer" }
	}
}
