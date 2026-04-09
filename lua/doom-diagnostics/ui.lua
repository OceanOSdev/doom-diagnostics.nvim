---@class DoomUI
---@field buf_id integer|nil The buffer ID used for the HUD
---@field win_id integer|nil The floating window ID
---@field current_image table|nil The image.nvim instance
local M = {}

local config = require("doom-diagnostics.config")

M.buf_id = nil
M.win_id = nil
M.current_image = nil

---@type table|nil The image.nvim engine
local ImageEngine = nil

---Check if the image engine is initialized
---@return boolean
function M.has_engine()
	return ImageEngine ~= nil
end

---Initialize the image engine
---@param engine table The image.nvim library
function M.init_engine(engine)
	ImageEngine = engine
end

---Ensure the buffer and floating window exist
---@param win_width integer The width of the window from config
function M.ensure_window(win_width)
	-- Check if the buffer exists and is valid
	if not M.buf_id or not vim.api.nvim_buf_is_valid(M.buf_id) then
		M.buf_id = vim.api.nvim_create_buf(false, true) -- Creat a new scratch buffer with listed = false, scratch = true
		vim.bo[M.buf_id].buftype = "nofile" -- Mark as non-file-backed (prevents writes)
		vim.bo[M.buf_id].bufhidden = "wipe" -- When buffer is no longer used it gets fully deleted
		vim.bo[M.buf_id].swapfile = false -- prevents swap files from being made for this buffer
		vim.bo[M.buf_id].modifiable = true -- allows plugin to update buffer contents
		vim.bo[M.buf_id].filetype = "doomguy" -- for funzies, incase I want to add some coloring to doomguy text later
	end

	-- Check if the window exists and is valid
	if not M.win_id or not vim.api.nvim_win_is_valid(M.win_id) then
		---@type vim.api.keyset.win_config
		local opts = {
			relative = "editor",
			width = win_width,
			height = 4,
			row = 1,
			col = vim.o.columns - (win_width + 2),
			style = "minimal",
			border = "rounded",
			focusable = false,
		}
		M.win_id = vim.api.nvim_open_win(M.buf_id, false, opts) -- Open the window with the buffer
	end
end

---Draw the Doomguy sprite based on pain level
---@param pain_level number The calculated total pain
---@param text string The text to show under the image
function M.draw(pain_level, text)
	local level = math.min(math.floor(pain_level / 10), 3)
	local path = config.sprites[level]

	if ImageEngine and M.win_id and M.buf_id then
		vim.api.nvim_win_set_config(M.win_id, {
			height = 4,
			col = vim.o.columns - 32,
			row = 1,
			relative = "editor",
			style = "minimal",
			border = "rounded",
		})

		vim.api.nvim_buf_set_lines(M.buf_id, 0, -1, false, {
			"",
			"",
			"",
			text,
		})

		if M.current_image then
			M.current_image:clear()
		end

		M.current_image = ImageEngine.from_file(path, {
			window = M.win_id,
			buffer = M.buf_id,
			width = 6,
			height = 3,
			x = 1,
			y = 0,
		})

		if M.current_image then
			M.current_image:render()
		end
	else
		M.render_ascii_fallback(pain_level, text)
	end
end

---Display ASCII art when image rendering is unavailable
---@param pain_level number
---@param status_text string
function M.render_ascii_fallback(pain_level, status_text)
	local lines = { "  (^_^)  ", "", status_text }
	if pain_level > 50 then
		lines = { "  (X_X)  ", "", status_text }
	elseif pain_level > 20 then
		lines = { "  (x_x)  ", "", status_text }
	elseif pain_level > 0 then
		lines = { "  (o_o)  ", "", status_text }
	end

	if M.buf_id and vim.api.nvim_buf_is_valid(M.buf_id) then
		vim.api.nvim_buf_set_lines(M.buf_id, 0, -1, false, lines)
	end
end

---Hide the HUD and clear images
function M.hide()
	if M.current_image then
		M.current_image:clear()
		M.current_image = nil
	end

	if M.win_id and vim.api.nvim_win_is_valid(M.win_id) then
		vim.api.nvim_win_close(M.win_id, true)
		M.win_id = nil
	end
end

return M
