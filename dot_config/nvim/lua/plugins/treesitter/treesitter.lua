return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	lazy = false,
	-- branch = "master",
	priority = 1000,
	config = function ()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/treesitter",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function ()
				pcall(vim.treesitter.start)
			end,
		})
	end
}

