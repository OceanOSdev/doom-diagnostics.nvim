---@class DoomWeights
---@field error integer
---@field warning integer
---@field hint integer

---@class DoomConfig
---@field win_width integer
---@field position string
---@field pain_weights DoomWeights
---@field force_ascii? boolean

local M = {}

-- Get the root directory of the plugin so we can locate assets
local plugin_root = debug.getinfo(1).source:sub(2):match("(.*)/lua/")

---@type DoomConfig
M.defaults = {
	win_width = 25,
	position = "top_right",
	pain_weights = {
		error = 10,
		warning = 5,
		hint = 1,
	},
	force_ascii = false,
}

---@type table<integer, string>
M.sprites = {
	[0] = plugin_root .. "/assets/doomguy-01-ok.png",
	[1] = plugin_root .. "/assets/doomguy-02-hurt.png",
	[2] = plugin_root .. "/assets/doomguy-03-bloodied.png",
	[3] = plugin_root .. "/assets/doomguy-04-critical.png",
}

return M
