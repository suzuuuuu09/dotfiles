local js_formatters = { "biome", "prettier", "prettierd", stop_after_first = true }
local python_formatters = { "ruff", "black", "isort", stop_after_first = true }

---@module "lazy"
---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo", "Format" },
	---@module "conform"
	opts = {
		formatters_by_ft = {
			json = js_formatters,
			javascript = js_formatters,
			typescript = js_formatters,
			javascriptreact = js_formatters,
			typescriptreact = js_formatters,
			astro = js_formatters,
			python = python_formatters,
			-- NOTE: SvelteはLSPの整形機能を使う
			clang = { "clang_format" },
		},
		formatters = {
			biome = {
				args = { "format", "--write", "--stdin-file-path", "$FILENAME" },
			},
		},
		format_on_save = {
			timeout_ms = 2000,
			lsp_fallback = true,
			quiet = false,
		},
		--[[ format_on_save = function(bufnr)
			local ft = vim.bo[bufnr].filetype

			-- もし formatters_by_ft に設定があるファイルなら、LSP は使わない
			if opts.formatters_by_ft[ft] then
				return { timeout_ms = 2000, lsp_format = "never" }
			end

			-- それ以外のファイルは LSP 整形を使う
			return { timeout_ms = 2000, lsp_format = "fallback" }
		end, ]]
	},
	config = function(_, opts)
		require("conform").setup(opts)
		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			require("conform").format({
				async = true,
				lsp_format = "fallback",
				range = range,
			})
		end, { range = true })
	end,
}
