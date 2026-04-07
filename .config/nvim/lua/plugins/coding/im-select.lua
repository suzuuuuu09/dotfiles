---@module "lazy"
---@type LazyPluginSpec
return {
	"keaising/im-select.nvim",
	config = function()
		require("im_select").setup({
			default_im_select = "net.mtgto.inputmethod.macSKK.ascii",
			set_previous_events = { "InsertEnter" },
			set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
			default_command = "macism",
			set_previous_im_on_default = true,
			async_switch_im = false,
		})
	end,
}
