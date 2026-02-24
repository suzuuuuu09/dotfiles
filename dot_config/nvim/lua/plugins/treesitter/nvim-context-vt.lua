return {
	"andersevenrud/nvim_context_vt",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		enabled = true,
		disable_virtual_lines_ft = {
			"markdown",
			"python",
			"yaml",
		}
	}
}
