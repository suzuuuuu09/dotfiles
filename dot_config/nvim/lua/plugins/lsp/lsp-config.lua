---@module "lazy"
---@type LazyPluginSpec[]
return {
	-- Base dependencies (must be loaded first)
	{
		"nvim-lua/plenary.nvim",
		lazy = false,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"mfussenegger/nvim-dap",
	},

	-- Mason core
	{
		"mason-org/mason.nvim",
		--[[ cmd = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonLog",
			"MasonUpdate",
		}, ]]
		event = "VeryLazy",
		opts = {},
	},

	-- LSP configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "folke/lazydev.nvim", lazy = false },
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
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

			local servers = {
				"lua_ls",
				"svelte",
				"tailwindcss",
				-- NOTE: typescript-tools.nvimを使うためコメントアウト
				-- "ts_ls",
				"html",
				"astro",
				"pyright",
				"jsonls",
				"cssls",
				"taplo",
				"bashls",
				"clangd",
				"ruff",
				"biome",
			}

			for _, server in ipairs(servers) do
				-- 個別設定ファイルの読み込みを試みる
				local has_custom_opts, custom_opts = pcall(require, "plugins.lsp.settings." .. server)

				local config = {
					on_attach = custom_on_attach,
				}

				-- 個別設定があればマージ
				if has_custom_opts then
					config = vim.tbl_deep_extend("force", config, custom_opts)
				end

				-- Neovim 0.11 の方式で設定を登録
				vim.lsp.config[server] = config
				vim.lsp.enable(server)
			end
		end,
	},

	-- Mason LSP bridge
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			-- "hrsh7th/cmp-nvim-lsp",  -- capabilitiesのために必要
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")

			-- cmp-nvim-lspからcapabilitiesを取得
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			mason_lspconfig.setup({
				ensure_installed = {
					"typos_lsp", -- spelling checker
					"lua_ls",
					"svelte",
					"tailwindcss",
					-- NOTE: typescript-tools.nvimを使うためコメントアウト
					-- "ts_ls",
					"html",
					"astro", -- Astro.js
					"pyright", -- python
					"jsonls", -- json
					"cssls", -- css
					"taplo", -- toml
					"bashls", -- bash
					"clangd", -- c/c++
				},
				automatic_installation = true,
			})

			-- インストールされたすべてのLSPにcapabilitiesを適用
			local installed_servers = mason_lspconfig.get_installed_servers()
			for _, server_name in ipairs(installed_servers) do
				-- 各LSPにcapabilitiesを設定
				if vim.lsp.config[server_name] then
					-- すでに設定がある場合はマージ
					vim.lsp.config[server_name].capabilities =
							vim.tbl_deep_extend("force", vim.lsp.config[server_name].capabilities or {}, capabilities)
				else
					-- 新規に設定を作成
					vim.lsp.config[server_name] = {
						capabilities = capabilities,
					}
				end
			end

			-- typos_lsp specific configuration
			vim.lsp.config.typos_lsp = {
				settings = {
					config = "~/.config/nvim/lua/plugins/.typos.toml",
				},
			}

			-- vim.lsp.enabledで自動有効化（Neovim 0.11.x）
			-- vim.lsp.enable = true
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
			ensure_installed = {
				"stylua",
				"ruff",     -- python linter
				-- "black", -- python formatter
				"cpplint",  -- c/c++ linter
				"clang_format", -- c/c++ formatter
			},
		},
	},

	-- Mason DAP bridge
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"mason-org/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			ensure_installed = {
				"python",
			},
		},
	},

	-- Mason tool installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"uv", -- python manager
			},
		},
	},
}
