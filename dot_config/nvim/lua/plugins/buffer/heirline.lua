return {
	"rebelot/heirline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-tree/nvim-web-devicons", opts = {} },
	config = function()
		local heirline = require("heirline")
		local utils = require("heirline.utils")
		local c = require("nord.colors").palette
		local icons = require("user.icons")

		-- =====================================================================
		-- 1. 自作の darken 関数
		-- =====================================================================
		local function darken(color, factor)
			if type(color) == "string" then
				color = tonumber(color:gsub("#", ""), 16)
			end
			local r = math.floor(bit.band(bit.rshift(color, 16), 0xff) * factor)
			local g = math.floor(bit.band(bit.rshift(color, 8), 0xff) * factor)
			local b = math.floor(bit.band(color, 0xff) * factor)
			return string.format("#%02x%02x%02x", r, g, b)
		end

		-- =====================================================================
		-- 2. ハイライトの設定
		-- =====================================================================
		local normal_bg = c.polar_night.origin
		local darker_bg = darken(normal_bg, 0.8)

		vim.api.nvim_set_hl(0, "TabLine", {
			bg = darker_bg,
			fg = utils.get_highlight("Comment").fg,
		})
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = normal_bg })

		vim.opt.showtabline = 2

		-- =====================================================================
		-- 3. コンポーネント定義
		-- =====================================================================

		-- LSP 診断情報 (Error/Warning)
		local TablineLSPStatus = {
			condition = function(self)
				return #vim.diagnostic.get(self.bufnr) > 0
			end,
			update = { "DiagnosticChanged", "BufEnter" },
			{
				provider = function(self)
					local errors = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.ERROR })
					return errors > 0 and (string.format(" %s%d", icons.error_icon or " ", errors)) or ""
				end,
				hl = { fg = c.aurora.red },
			},
			{
				provider = function(self)
					local warnings = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.WARN })
					return warnings > 0 and (string.format(" %s%d", icons.warn_icon or " ", warnings)) or ""
				end,
				hl = { fg = c.aurora.yellow },
			},
		}

		local FileIcon = {
			init = function(self)
				local filename = self.filename
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_color =
						require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
			end,
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function(self)
				return { fg = self.icon_color }
			end,
		}

		local TablineBufnr = {
			provider = function(self)
				return tostring(self.bufnr) .. ". "
			end,
			hl = { fg = c.snow_storm.origin },
		}

		local TablineFileName = {
			provider = function(self)
				local filename = self.filename
				filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
				return filename
			end,
			hl = function(self)
				return { bold = self.is_active or self.is_visible, italic = not self.is_active }
			end,
		}

		local TablineDirectoryName = {
			condition = function(self)
				local bufs = vim.api.nvim_list_bufs()
				local count = 0
				local target_name = vim.fn.fnamemodify(self.filename, ":t")
				if target_name == "" then
					return false
				end
				for _, bufnr in ipairs(bufs) do
					if
							vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
					then
						local name = vim.api.nvim_buf_get_name(bufnr)
						if vim.fn.fnamemodify(name, ":t") == target_name then
							count = count + 1
						end
					end
				end
				return count > 1
			end,
			provider = function(self)
				local dir = vim.fn.fnamemodify(self.filename, ":h:t")
				if dir == "." then
					return ""
				end
				return string.format(" %s", dir)
			end,
			hl = { fg = utils.get_highlight("Comment").fg, italic = true },
		}

		local TablineFileFlags = {
			{
				condition = function(self)
					return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
				end,
				provider = " " .. icons.modified_icon,
				hl = { fg = c.aurora.green },
			},
			{
				condition = function(self)
					return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
							or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
				end,
				provider = function(self)
					if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
						return "  "
					else
						return " "
					end
				end,
				hl = { fg = c.aurora.orange },
			},
		}

		local TablineFileNameBlock = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(self.bufnr)
			end,
			hl = function(self)
				return self.is_active and "TabLineSel" or "TabLine"
			end,
			on_click = {
				callback = function(_, minwid, _, button)
					if button == "m" then
						vim.schedule(function()
							vim.api.nvim_buf_delete(minwid, { force = false })
						end)
					else
						vim.api.nvim_win_set_buf(0, minwid)
					end
				end,
				minwid = function(self)
					return self.bufnr
				end,
				name = "heirline_tabline_buffer_callback",
			},
			TablineBufnr,
			FileIcon,
			TablineFileName,
			TablineDirectoryName,
			TablineLSPStatus, -- ここに診断情報を追加
			TablineFileFlags,
		}

		local TablineCloseButton = {
			condition = function(self)
				return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
			end,
			{ provider = " " },
			{
				provider = " " .. icons.close_icon,
				hl = { fg = c.snow_storm.origin },
				on_click = {
					callback = function(_, minwid)
						vim.schedule(function()
							vim.api.nvim_buf_delete(minwid, { force = false })
							vim.cmd.redrawtabline()
						end)
					end,
					minwid = function(self)
						return self.bufnr
					end,
					name = "heirline_tabline_close_buffer_callback",
				},
			},
		}

		local TablineBufferBlock = utils.surround({ "", "" }, function(self)
			return utils.get_highlight(self.is_active and "TabLineSel" or "TabLine").bg
		end, { TablineFileNameBlock, TablineCloseButton })

		local BufferLine = utils.make_buflist(
			TablineBufferBlock,
			{ provider = "", hl = { fg = c.snow_storm.origin } },
			{ provider = "", hl = { fg = c.snow_storm.origin } }
		)

		heirline.setup({
			tabline = BufferLine,
		})
	end,
}
