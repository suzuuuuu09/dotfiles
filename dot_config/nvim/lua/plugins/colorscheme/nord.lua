-- https://github.com/gbprod/nord.nvim
return {
	"gbprod/nord.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("nord").setup({
			transparent = true,
			on_highlights = function(hl, p)
				hl.LineNr = { fg = p.polar_night.brightest }
				-- Tree-sitter
				hl["@property.json"] = { fg = p.frost.polar_water }
				hl["@punctuation.bracket.json"] = { fg = p.frost.ice }

				-- tiny-inline-diagnostic.nvim
				hl.DiagnosticError = { fg = p.aurora.red }
				hl.DiagnosticWarn = { fg = p.aurora.yellow }
				hl.DiagnosticInfo = { fg = p.frost.ice }
				hl.DiagnosticHint = { fg = p.frost.artic_water }

				-- which-key.nvim
				hl.NormalFloat = { bg = "NONE" }
				hl.FloatBorder = { fg = p.polar_night.brightest, bg = "NONE" }

				-- package-info.nvim
				hl.PackageInfoOutdatedVersion = {
					fg = p.aurora.orange,
					ctermfg = 173,
					bg = "NONE",
					ctermbg = "NONE",
				}
				hl.PackageInfoUpToDateVersion = {
					fg = p.polar_night.origin,
					ctermfg = 237,
					bg = "NONE",
					ctermbg = "NONE",
				}
				hl.PackageInfoInErrorVersion = { fg = p.aurora.red }
			end,
		})
		vim.cmd.colorscheme("nord")
	end,
}

-- ── nord colors ────────────────────────────────────────────
-- +---------------------------------------------------------+
-- | polar_night																						 |
-- | origin = "#2E3440", -- nord0 in palette								 |
-- | bright = "#3B4252", -- nord1 in palette								 |
-- | brighter = "#434C5E", -- nord2 in palette							 |
-- | brightest = "#4C566A", -- nord3 in palette							 |
-- | light = "#616E88", -- out of palette										 |
-- | snow_storm																							 |
-- | origin = "#D8DEE9", -- nord4 in palette								 |
-- | brighter = "#E5E9F0", -- nord5 in palette							 |
-- | brightest = "#ECEFF4", -- nord6 in palette							 |
-- | frost																									 |
-- | polar_water = "#8FBCBB", -- nord7 in palette						 |
-- | ice = "#88C0D0", -- nord8 in palette										 |
-- | artic_water = "#81A1C1", -- nord9 in palette						 |
-- | artic_ocean = "#5E81AC", -- nord10 in palette					 |
-- | aurora																									 |
-- | red = "#BF616A", -- nord11 in palette									 |
-- | orange = "#D08770", -- nord12 in palette								 |
-- | yellow = "#EBCB8B", -- nord13 in palette								 |
-- | green = "#A3BE8C", -- nord14 in palette								 |
-- | purple = "#B48EAD", -- nord15 in palette								 |
-- | none = "NONE",																					 |
-- +---------------------------------------------------------+
