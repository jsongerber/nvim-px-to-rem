---@class cmp-cmp-nvim-px-to-rem.Options
---@field root_font_size number
---@field decimal_count number
---@field filetypes string[]

local utils = require("nvim-px-to-rem.utils")

local M = {}

---@param opts blink-cmp-nvim-px-to-rem.Options
function M.new(opts)
	return setmetatable({
		root_font_size = opts.root_font_size,
		decimal_count = opts.decimal_count,
		filetypes = opts.filetypes,
	}, { __index = M })
end

---@return string
function M:get_keyword_pattern()
	return [[\d\+\(\.\d\+\)\?\(px\?\)\?]]
end

function M:is_available()
	return vim.tbl_contains(self.filetypes, vim.bo.filetype)
end

function M:complete(params, callback)
	local input, word_start, word_end =
		utils.get_start_of_word_under_cursor(params.context.cursor_line, params.context.cursor.character - 1)

	if input == "" then
		callback()
		return
	end

	local px = string.match(input, "%d+%.?%d*")

	local px_size = tonumber(px)
	if px_size == nil then
		callback()
		return
	end
	local rem_size = px_size / self.root_font_size
	local pxrem = string.format("%srem", tostring(utils.round(rem_size, self.decimal_count)))

	local items = {
		{
			label = px .. "px -> " .. pxrem,
			-- filterText = input,
			insertText = pxrem,
			kind = vim.lsp.protocol.CompletionItemKind.Value,
			insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
		},
	}

	local is_incomplete = string.find(input, "(-?%d+%.?%d*)px") == nil

	callback({
		items = items,
		isIncomplete = is_incomplete,
	})
end

function M.setup(opts)
	local ok, cmp = pcall(require, "cmp")
	if ok then
		cmp.register_source("lazydev", M.new(opts))
	end
end

return M
