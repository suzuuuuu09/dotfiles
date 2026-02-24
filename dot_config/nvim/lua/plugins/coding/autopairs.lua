return {
  "windwp/nvim-autopairs",
	event = "InsertEnter",
  opts = {},
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    
    -- プラグインをセットアップ
    npairs.setup(opts)
    
    -- カスタムルールを追加
    npairs.add_rules({
      Rule(" ", " "):with_pair(function(options)
        local pair = options.line:sub(options.col - 1, options.col)
        return vim.tbl_contains({ "()", "[]", "{}" }, pair)
      end),
      Rule("( ", " )")
        :with_pair(function()
          return false
        end)
        :with_move(function(options)
          return options.prev_char:match(".%)") ~= nil
        end)
        :use_key(")"),
      Rule("{ ", " }")
        :with_pair(function()
          return false
        end)
        :with_move(function(options)
          return options.prev_char:match(".%}") ~= nil
        end)
        :use_key("}"),
      Rule("[ ", " ]")
        :with_pair(function()
          return false
        end)
        :with_move(function(options)
          return options.prev_char:match(".%]") ~= nil
        end)
        :use_key("]"),
    })
  end,
}

