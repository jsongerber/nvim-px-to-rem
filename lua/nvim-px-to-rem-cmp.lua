local utils = require("utils")

local M = {}

M.add_to_cmp = function(font_size, decimal_count, filetypes)
	local source = {}

	source.priority = 9999

	source.new = function()
		return setmetatable({}, { __index = source })
	end

	source.get_keyword_pattern = function()
		-- return [=[\%(\s\|^\)\zs:[[:alnum:]_\-\+]*:\?]=]
		-- return "(%d+%.?%d*)px"
		return [[\d\+\(\.\d\+\)\?\(px\?\)\?]]
	end

	source.is_available = function()
		return vim.tbl_contains(filetypes, vim.bo.filetype)
	end

	source.complete = function(self, params, callback)
		local input = string.sub(params.context.cursor_before_line, params.offset)
		local px = string.match(input, "%d+%.?%d*")

		local px_size = tonumber(px)
		local rem_size = px_size / font_size
		local pxrem = string.format("%srem", tostring(utils.round(rem_size, decimal_count)))
		local items = {
			{
				-- word = input,
				label = px .. "px -> " .. pxrem,
				insertText = pxrem,
				-- filterText = input,
			},
		}

		self.items = items
		local is_incomplete = string.find(input, "(-?%d+%.?%d*)px") == nil
		callback({ items = items, isIncomplete = is_incomplete })
	end

	return source
end

return M
