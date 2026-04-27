---@module "lazy"
---@type LazyPluginSpec
return {
	"iamkarasik/sonarqube.nvim",
	config = function()
		local extension_path = vim.fn.stdpath("data") .. "/mason/packages/sonarlint-language-server/extension"
		require("sonarqube").setup({
			lsp = {
				cmd = {
					vim.fn.exepath("java"),
					"-jar",
					extension_path .. "/server/sonarlint-ls.jar",
					"-stdio",
					"-analyzers",
					extension_path .. "/analyzers/sonargo.jar",
					extension_path .. "/analyzers/sonarhtml.jar",
					extension_path .. "/analyzers/sonariac.jar",
					extension_path .. "/analyzers/sonarjava.jar",
					extension_path .. "/analyzers/sonarjavasymbolicexecution.jar",
					extension_path .. "/analyzers/sonarjs.jar",
					extension_path .. "/analyzers/sonarphp.jar",
					extension_path .. "/analyzers/sonarpython.jar",
					extension_path .. "/analyzers/sonartext.jar",
					extension_path .. "/analyzers/sonarxml.jar",
				},
			},
			csharp = {
				enabled = true,
				omnisharpDirectory = extension_path .. "/omnisharp",
				csharpOssPath = extension_path .. "/analyzers/sonarcsharp.jar",
				csharpEnterprisePath = extension_path .. "/analyzers/csharpenterprise.jar",
			},
		})
	end,
}
