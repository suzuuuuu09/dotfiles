---@module "lazy"
---@type LazyPluginSpec
return {
	"keaising/im-select.nvim",
	config = function()
		require("im_select").setup({
			default_im_select = "net.mtgto.inputmethod.macSKK.ascii",
			default_command = "macism",
			set_previous_im_on_default = true,
		})
	end,
}
