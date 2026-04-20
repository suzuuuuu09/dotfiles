local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function get_filename()
	local filename = vim.fn.expand("%:t:r")
	return filename
end

return {
	s(
		"@",
		fmt(
			[[
				public class <> {
					public static void main(String[] args) {
						<>
					}
				}
			]],
			{ f(get_filename), i(1) },
			{ delimiters = "<>" }
		)
	),
}
