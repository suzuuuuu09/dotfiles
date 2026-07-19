local lsp_servers = {
	"astro",
	"bashls",
	"biome",
	"clangd",
	"cssls",
	"fish_lsp",
	"html",
	"jsonls",
	"lua_ls",
	"nil_ls",
	"pyright",
	"ruff",
	"svelte",
	"taplo",
	"tailwindcss",
	"typos_lsp",
	"jdtls",
	-- NOTE: typescript-tools.nvimを使うためコメントアウト
	-- "ts_ls",
}

local null_ls_sources = {
	"stylua",
	"ruff", -- python linter
	-- "black", -- python formatter
	"cpplint", -- c/c++ linter
	"clang_format", -- c/c++ formatter
	"prettier", -- general formatter
	"alejandra", -- Nix formatter
	"kulala-fmt",
}

local generic_tools = {
	"uv", -- python manager
}

---@module "lazy"
---@type LazyPluginSpec[]
return {
	-- Mason core
	{
		"mason-org/mason.nvim",
		event = "VeryLazy",
		opts = {
			PATH = "append",
		},
	},

	-- LSP configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "folke/lazydev.nvim", lazy = false },
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			--[[ -- すべてのLSPに共通の設定
			vim.lsp.config("*", {
				root_markers = { ".git" },
			})

			local lang_servers = {
				"lua_ls",
			}
			
		  for _, server in ipairs(lang_servers) do
				vim.lsp.enable(server)
			end ]]
			local custom_on_attach = function(client, bufnr)
				local status, conform = pcall(require, "conform")
				if status then
					local formatters = conform.list_formatters(bufnr)
					if #formatters > 0 then
						client.server_capabilities.documentFormattingProvider = false
					end
				end
			end

			for _, server in ipairs(lsp_servers) do
				local config = {
					on_attach = custom_on_attach,
				}

				-- Neovim 0.11+ の方式で設定を登録
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end,
	},

	-- Mason LSP bridge
	{
		"mason-org/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			-- "hrsh7th/cmp-nvim-lsp",  -- capabilitiesのために必要
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = lsp_servers,
				automatic_enable = false,
			})
		end,
	},

	-- Mason null-ls bridge
	{
		"jay-babu/mason-null-ls.nvim",
		event = "VeryLazy",
		dependencies = {
			"mason-org/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		opts = {
			ensure_installed = null_ls_sources,
			automatic_installation = true,
		},
	},

	-- Mason tool installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = generic_tools,
		},
	},
}
