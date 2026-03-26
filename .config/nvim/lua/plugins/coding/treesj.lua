---@module "lazy"
---@type LazyPluginSpec
return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	cmd = "TSJToggle",
	opts = {
		use_default_keymaps = false,
		join = {
			space_in_brackets = true,
		}
	},
	keys = {
		{ "<leader>lj", "<CMD>TSJToggle<CR>", desc = "Toggle split/join" },
	},
}

