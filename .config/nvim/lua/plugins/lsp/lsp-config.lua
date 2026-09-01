local lsp_servers = {
	-- "astro",
	"bashls",
	"biome",
	"clangd",
	"cssls",
	"fish_lsp",
	"html",
	"jsonls",
	"lua_ls",
	"nixd",
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

---@module "lazy"
---@type LazyPluginSpec[]
return {
	-- LSP configuration
	{
		"neovim/nvim-lspconfig",
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
				if client.name == "nixd" and client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end

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
}
