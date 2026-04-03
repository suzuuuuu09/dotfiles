---@module "lazy"
---@type LazyPluginSpec
return {
	"folke/sidekick.nvim",
	event = "VeryLazy",
	keys = {
		-- NES (Copilotの次世代提案) の適用・ジャンプ
		{
			"<Tab>",
			function()
				if require("sidekick").nes_jump_or_apply() then
					return ""
				else
					return "<Tab>"
				end
			end,
			expr = true,
			desc = "Next Edit Suggestion",
		},
		-- AIチャットターミナルの起動/切り替え
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle",
		},
		-- 使用するAIツール (Claude, Gemini, aider等) の選択
		{
			"<leader>as",
			function()
				require("sidekick.cli").select()
			end,
			desc = "Select AI CLI",
		},
		-- 現在のファイルや選択範囲をAIに送信
		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Send File to AI",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = "x",
			desc = "Send Selection to AI",
		},
		-- カスタムプロンプトの選択
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			desc = "Select AI Prompt",
		},
	},
}
