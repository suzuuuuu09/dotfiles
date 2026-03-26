---@module "lazy"
---@type LazyPluginSpec
return {
	"pmizio/typescript-tools.nvim",
	ft = {
		"typescript",
		"typescriptreact",
		"javascript",
		"javascriptreact",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
	},
	opts = {
		settings = {
			expose_as_code_action = "all",
			tsserver_max_memory = "auto",
			-- NOTE: tsserver_pathをnilに設定すると、プロジェクトのローカルtsserverが優先される
			-- tsserver_path = nil,
			tsserver_file_preferences = {
				includeInlayParameterNameHints = "all",
				includeInlayVariableTypeHints = true,
			},
		},
	},
}
