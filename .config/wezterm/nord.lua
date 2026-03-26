---@class Nord.Palette.PolarNight
---@field origin string Nord 0 #2e3440
---@field darkest string Nord 1 #3b4252
---@field darker string Nord 2 #434c5e
---@field dark string Nord 3 #4c566a

---@class Nord.Palette.SnowStorm
---@field origin string Nord 4 #d8dee9
---@field brighter string Nord 5 #e5e9f0
---@field brightest string Nord 6 #eceff4

---@class Nord.Palette.Frost
---@field polar_water string Nord 7 #8fbcbb
---@field ice string Nord 8 #88c0d0
---@field snow string Nord 9 #81a1c1
---@field ocean string Nord 10 #5e81ac

---@class Nord.Palette.Aurora
---@field red string Nord 11 #bf616a
---@field orange string Nord 12 #d08770
---@field yellow string Nord 13 #ebcb8b
---@field green string Nord 14 #a3be8c
---@field purple string Nord 15 #b48ead

---@class Nord.Palette
---@field polar_night Nord.Palette.PolarNight
---@field snow_storm Nord.Palette.SnowStorm
---@field frost Nord.Palette.Frost
---@field aurora Nord.Palette.Aurora

local M = {}

--- @type Nord.Palette
M = {
	polar_night = {
		origin = "#2e3440",
		darkest = "#3b4252",
		darker = "#434c5e",
		dark = "#4c566a",
	},
	snow_storm = {
		origin = "#d8dee9",
		brighter = "#e5e9f0",
		brightest = "#eceff4",
	},
	frost = {
		polar_water = "#8fbcbb",
		ice = "#88c0d0",
		snow = "#81a1c1",
		ocean = "#5e81ac",
	},
	aurora = {
		red = "#bf616a",
		orange = "#d08770",
		yellow = "#ebcb8b",
		green = "#a3be8c",
		purple = "#b48ead",
	},
}

return M
