local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"M",
		fmt(
			[[
        local M = {}

        <>

        return M
    ]],
			{ i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		"fun",
		fmt(
			[[
        function {}({})
          {}
        end
      ]],
			{ i(1), i(2), i(0) }
		)
	),
	s(
		"lazys",
		fmt(
			[[
				---@module "lazy"
				---@type LazyPluginSpec
				return {
					"<>",
				}
			]],
			{
				i(1, "author/repo"),
			},
			{ delimiters = "<>" }
		)
	),
	s(
		"snippet",
		fmt(
			[=[
        s(
          "<trigger>",
          fmt(
            [[
              <text>
            ]],
            { i(1, "<placeholder>") }
          )
        ),

		  ]=],
			{
				trigger = i(1, "trigger"),
				text = i(2, "text"),
				placeholder = i(0, "placeholder"),
			},
			{ delimiters = "<>" }
		)
	),
	s(
		"snippet-require",
		fmt(
			[[
        local ls = require("luasnip")
        local s = ls.snippet
        local i = ls.insert_node
        local fmt = require("luasnip.extras.fmt").fmt
        return {
          <>
        }
		  ]],
			{ i(0, "snippet") },
			{ delimiters = "<>" }
		)
	),
}
