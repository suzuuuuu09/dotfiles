local function format_color(ctx)
	local doc = ctx.item.documentation or ""
	if type(doc) == "table" then
		doc = doc.value or ""
	end

	return require("nvim-highlight-colors").format(doc, { kind = ctx.kind })
end

return {
	"saghen/blink.cmp",
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"L3MON4D3/LuaSnip",
		{ "brenoprata10/nvim-highlight-colors" },
	},
	config = function()
		require("blink.cmp").setup({
			sources = require("plugins.cmp._sources").sources,
			keymap = require("plugins.cmp._keymap").keymap,
			snippets = { preset = "luasnip" },
			--[[ signature = {
				enabled = true,
				window = {
					border = "rounded",
					winblend = 15,
				},
			}, ]]
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0,
					-- border = "rounded",
					-- winblend = 15,
					-- window = { border = "rounded" },
				},
				menu = {
					-- winblend = 10, -- 半透明にはなるけど枠線が異様に太くなる
					-- window = { border = "rounded" },
					-- border = "rounded",
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "source_name" },
						},
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									local color_item = format_color(ctx)

									if color_item and color_item.abbr ~= "" then
										return color_item.abbr .. ctx.icon_gap
									end
									return ctx.kind_icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									local color_item = format_color(ctx)

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
