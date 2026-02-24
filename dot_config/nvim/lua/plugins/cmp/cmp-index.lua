return {
	"saghen/blink.cmp",
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
		"moyiz/blink-emoji.nvim",
		{ "folke/lazydev.nvim" },
		{ "brenoprata10/nvim-highlight-colors" },
	},
	config = function()
		require("blink.cmp").setup({
			sources = require("plugins.cmp._sources").sources,
			keymap = require("plugins.cmp._keymap").keymap,
			snippets = { preset = "luasnip" },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 0 },
				menu = {
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label",      "label_description", gap = 1 },
							{ "source_name" },
						},
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									-- nvim-highlight-colors による色の取得
									local item = ctx.item
									-- documentation または label から色情報を抽出
									local doc = item.documentation or ""
									-- documentation が table の場合（LSP仕様）に対応
									if type(doc) == "table" then
										doc = doc.value or ""
									end

									local color_item = require("nvim-highlight-colors").format(doc, { kind = ctx.kind })

									if color_item and color_item.abbr ~= "" then
										return color_item.abbr .. ctx.icon_gap
									end
									return ctx.kind_icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									local item = ctx.item
									local doc = item.documentation or ""
									if type(doc) == "table" then
										doc = doc.value or ""
									end

									local color_item = require("nvim-highlight-colors").format(doc, { kind = ctx.kind })

									if color_item and color_item.abbr_hl_group then
										return color_item.abbr_hl_group
									end
									return "BlinkCmpKind" .. ctx.kind
								end,
							},
						},
					},
				},
			},
		})
	end,
}
