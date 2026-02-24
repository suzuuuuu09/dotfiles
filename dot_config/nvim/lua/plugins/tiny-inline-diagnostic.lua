return {
	"rachartier/tiny-inline-diagnostic.nvim",
	---@module "tiny-inline-diagnostic"
	opts = {
		transparent_cursorline = true,
		hi = {
			error = "DiagnosticError",
			warn = "DiagnosticWarn",
			info = "DiagnosticInfo",
			hint = "DiagnosticHint",
		},
		options = {
			multilines = {
				enabled = true,
				always_show = true,
			},
			show_source = false,
			-- インサートモードでもエラー文を表示
			throttle = 0,
			show_all_diags_on_cursorline = false,
			enable_on_insert = false,
			format = function(diag)
				local message = diag.message
				local source = diag.source
				local code = diag.code

				-- ソースとコードがある場合にメッセージに付け加える
				if source and code then
					return string.format("%s (%s: %s)", message, source, code)
				elseif source then
					return string.format("%s (%s)", message, source)
				end

				return message
			end,
		},
	},
	config = function(_, opts)
		require("tiny-inline-diagnostic").setup(opts)
		vim.diagnostic.config({
			virtual_text = false,
			underline = true,     -- 波線を常に表示
			update_in_insert = true, -- インサートモードでも診断を更新
		})                      -- Disable Neovim's default virtual text diagnostics
		-- エラーのアイコン表示を変更
		local icons = require("user.icons")
		local signs = {
			Error = icons.diag.error_icon,
			Warn = icons.diag.warning_icon,
			Hint = icons.diag.hint_icon,
			Info = icons.diag.info_icon,
		}
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end
	end,
}
