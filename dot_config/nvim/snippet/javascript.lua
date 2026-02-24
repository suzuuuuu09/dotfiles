local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cl",
		fmt(
			[[
			console.log("{}");
			{}
    ]],
			{ i(1), i(0) }
		-- { delimiters = "<>" }
		)
	),
	s(
		"interface",
		fmt(
			[[
				interface <> {
					<>: <>;
				}
	    ]],
			{ i(1, "User"), i(2, "name"), i(3, "string") },
			{ delimiters = "<>" }
		)
	),
}
