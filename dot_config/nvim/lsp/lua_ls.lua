return {
	-- cmd = { "lua-language-server" },
	-- filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selense.toml",
		"selense.yml",
		".git",
	},
	-- Language Server固有の設定
	settings = {
		Lua = {
			-- LuaJITランタイムを使用（Neovim用）
			-- runtime = {
			-- 	version = "LuaJIT",
			-- },
			-- ワークスペース設定
			-- workspace = {
			-- 	checkThirdParty = false,
			-- },
			-- 診断設定
			diagnostics = {
				enabled = true,
			},
		},
	},
}
