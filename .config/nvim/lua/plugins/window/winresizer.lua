return {
	"simeji/winresizer",
	cmd = "WinResizerStartResize",
	desc = 'Resize window layout',
	init = function()
		vim.g.winresizer_vert_resize = 1
		vim.g.winresizer_horiz_resize = 1
	end,
	keys = {
		{ "<C-w>r", "<cmd>WinResizerStartResize<CR>", desc = "Start window resize mode" },
	}
}

