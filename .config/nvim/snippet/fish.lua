local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"fun",
		fmt(
			[[
				function {}
					{}
				end
			]],
			{ i(1), i(0) }
		)
	),
}
