-- https://github.com/monaga/dial.nvim
return {
	"monaqa/dial.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		-- Normal mode
		{
			"+",
			function() require("dial.map").manipulate("increment", "normal") end,
			mode = "n",
			desc = "Increment number under the cursor",
		},
		{
			"-",
			function() require("dial.map").manipulate("decrement", "normal") end,
			mode = "n",
			desc = "Decrement number under the cursor",
		},
		{
			"g+",
			function() require("dial.map").manipulate("increment", "gnormal") end,
			mode = "n",
			desc = "Increment number under the cursor",
		},
		{
			"g-",
			function() require("dial.map").manipulate("decrement", "gnormal") end,
			mode = "n",
			desc = "Decrement number under the cursor",
		},
		-- Visual mode
		{
			"+",
			function() require("dial.map").manipulate("increment", "visual") end,
			mode = "v",
			desc = "Increment number under the cursor (visual)",
		},
		{
			"-",
			function() require("dial.map").manipulate("decrement", "visual") end,
			mode = "v",
			desc = "Decrement number under the cursor (visual)",
		},
		{
			"g+",
			function() require("dial.map").manipulate("increment", "gvisual") end,
			mode = "v",
			desc = "Increment number under the cursor (visual)",
		},
		{
			"g-",
			function() require("dial.map").manipulate("decrement", "gvisual") end,
			mode = "v",
			desc = "Decrement number under the cursor (visual)",
		}
	},
	config = function()
		local augend = require "dial.augend"
		require("dial.config").augends:register_group {
			default = {
				augend.integer.alias.decimal, -- 1, 2, 3, 4, 5, ...
				augend.integer.alias.hex, -- 0x1, 0x2, 0x3, 0x4, 0x5, ...
				augend.date.alias["%Y/%m/%d"], -- 2025/01/23
				augend.date.alias["%m/%d"], -- 01/23, 04/15, 12/25, ...
				augend.date.alias["%-m/%-d"], -- 1/23, 4/15, 12/25, ...
				augend.date.alias["%Y-%m-%d"], -- 2025-1-23
				augend.date.alias["%Y年%-m月%-d日"], -- 2025年1月23日
				augend.date.alias["%Y年%-m月%-d日(%ja)"], -- 2025年1月23日(木)
				augend.date.alias["%H:%M:%S"], -- 12:34:56
				augend.date.alias["%H:%M"], -- 12:34
				augend.constant.alias.ja_weekday, -- 月, 火, 水, 木, 金, 土, 日
				augend.constant.alias.ja_weekday_full, -- 月曜日, 火曜日, 水曜日, 木曜日, 金曜日, 土曜日, 日曜日
				augend.constant.alias.bool, -- true, false
				augend.semver.alias.semver, -- 1.2.0, 1.2.4, 1.3.0, 2.0.0, ...
				augend.constant.new {
					elements = { "&&", "||" },
					word = false,
					cyclic = true,
				},
				augend.constant.new {
					elements = { "and", "or" },
					word = false,
					cyclic = true,
				},
				augend.constant.new {
					elements = { "True", "False" },
					word = false,
					cyclic = true,
				},
				augend.constant.new {
					elements = { "==", "!=" },
					word = false,
					cyclic = true,
				},
				augend.constant.new {
					elements = { ">=", "<=", "<", ">" },
					word = false,
					cyclic = true,
				},
			},
			visual = {
				augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
      },
    }
  end,
}
