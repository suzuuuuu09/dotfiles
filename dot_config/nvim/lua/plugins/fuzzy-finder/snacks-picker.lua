---@module "lazy"
---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		picker = {
			enabled = true,
			exclude = {
				"node_modules",
				".git",
				"dist",
				"build",
			},
			sources = {
				buffers = {
					sort_lastused = false, -- true: 最後に使用した順にソート、false: バッファ番号順にソート
					unloaded = true,  -- ロードされていないバッファも表示
				},
			},
		},
	},
	keys = {
		{
			"<leader>ff",
			function()
				require("snacks.picker").files()
			end,
			desc = "Find files",
		},
		{
			"<leader>fF",
			function()
				require("snacks.picker").files({ hidden = true, ignored = true })
			end,
			desc = "Find hidden files",
		},
		{
			"<leader>f<CR>",
			function()
				require("snacks.picker").resume()
			end,
			desc = "Resume previous search",
		},
		{
			"<leader>f'",
			function()
				require("snacks.picker").marks()
			end,
			desc = "Find marks",
		},
		{
			"<leader>fl",
			function()
				require("snacks.picker").lines()
			end,
			desc = "Find lines",
		},
		{
			"<leader>fb",
			function()
				require("snacks.picker").buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>fc",
			function()
				require("snacks.picker").grep_word()
			end,
			desc = "Find word under cursor",
		},
		{
			"<leader>fC",
			function()
				require("snacks.picker").commands()
			end,
			desc = "Find commands",
		},
		{
			"<leader>fg",
			function()
				require("snacks.picker").git_files()
			end,
			desc = "Find git files",
		},
		{
			"<leader>fw",
			function()
				require("snacks.picker").grep()
			end,
			desc = "Find word",
		},
		{
			"<leader>fp",
			function()
				require("snacks.picker").projects()
			end,
			desc = "Find projects",
		},
		{
			"<leader>fh",
			function()
				require("snacks.picker").help()
			end,
			desc = "Find help",
		},
		{
			"<leader>fk",
			function()
				require("snacks.picker").keymaps()
			end,
			desc = "Find keymaps",
		},
		{
			"<leader>fm",
			function()
				require("snacks.picker").man()
			end,
			desc = "Find manuals",
		},
		{
			"<leader>fC",
			function()
				require("snacks.picker").files({ dirs = { vim.fn.stdpath("config") } })
			end,
			desc = "Find config files",
		},
		{
			"<leader>fs",
			function()
				require("snacks.picker").smart()
			end,
			desc = "Find buffers/files/recent",
		},
		{
			"<leader>ft",
			function()
				require("snacks.picker").todo_comments()
			end,
			desc = "Find TODO comments",
		},
		{
			"<leader>fT",
			function()
				require("snacks.picker").colorschemes()
			end,
			desc = "Find colorschemes",
		},
		{
			"<leader>lD",
			function()
				require("snacks.picker").diagnostics()
			end,
			desc = "Find diagnostics",
		},
	},
}
