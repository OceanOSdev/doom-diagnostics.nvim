---@class DoomGuy
---@field config DoomConfig The merged configuration for the plugin
---@field enabled boolean Whether the HUD is currently active
local M = {}

local ui = require("doom-diagnostics.ui")
local config = require("doom-diagnostics.config")

M.enabled = true

---Toggle the visibility of the Doomguy HUD
function M.toggle()
	M.enabled = not M.enabled
	if not M.enabled then
		ui.hide()
	else
		M.render_doomguy()
	end
end

---Calculate the total pain level based on weighted diagnostics
---@return integer total_pain The sum of weighted errors, warnings, and hints
function M.calculate_pain()
	local errs = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local warns = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

	local total_pain = (errs * M.config.pain_weights.error)
		+ (warns * M.config.pain_weights.warning)
		+ (hints * M.config.pain_weights.hint)

	return total_pain
end

---Main rendering logic: checks context and updates UI
function M.render_doomguy()
	if not M.enabled then
		return
	end

	-- Don't do anything if we are in the middle of a command line window
	-- or other special temporary states
	if vim.fn.getcmdwintype() ~= "" then
		return
	end

	-- Ignore "special" buffers (NvimTree, Telescope, etc.)
	local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
	local ignore_filetypes = { "TelescopePrompt", "snacks_picker_input", "NvimTree", "neo-tree" }
	local is_ignored_ft = vim.tbl_contains(ignore_filetypes, filetype)
	if buftype ~= "" or is_ignored_ft then
		ui.hide()
		return
	end

	-- If there are no clients, there are no diagnostics to report
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		ui.hide()
		return
	end

	ui.ensure_window(M.config.win_width)
	local pain = M.calculate_pain()

	local status_text = pain > 0 and " FIX ERRORS TO HEAL!" or " STATUS: HEALED"

	local ok = pcall(ui.draw, pain, status_text, M.config.win_width)
	if not ok then
		ui.render_ascii_fallback(pain, status_text)
	end
end

---Initialize the plugin with user options
---@param user_opts DoomConfig|nil Configuration overrides
function M.setup(user_opts)
	M.config = vim.tbl_deep_extend("force", config.defaults, user_opts or {})

	local ok, image_api = pcall(require, "image")
	if ok and not M.config.force_ascii then
		ui.init_engine(image_api)
	end

	vim.api.nvim_create_user_command("DoomToggle", M.toggle, {
		desc = "Toggle the Doomguy health display",
	})

	M.create_autocmds()
end

---Setup autocmds for diagnostic updates and buffer switching
function M.create_autocmds()
	local group = vim.api.nvim_create_augroup("DoomDiagnostics", { clear = true })

	vim.api.nvim_create_autocmd({ "VimEnter", "DiagnosticChanged", "BufEnter", "WinEnter", "LspAttach" }, {
		group = group,
		callback = function()
			-- Wrap in schedule to avoid E565 (textlock)
			vim.schedule(function()
				local bufnr = vim.api.nvim_get_current_buf()
				if vim.api.nvim_buf_is_valid(bufnr) then
					M.render_doomguy()
				end
			end)
		end,
	})

	vim.api.nvim_create_autocmd("BufLeave", {
		group = group,
		callback = function()
			-- Clean slate before entering next buffer/window
			ui.hide()
		end,
	})
end

return M
