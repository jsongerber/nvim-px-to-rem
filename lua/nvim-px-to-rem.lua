local M = {}

local utils = require("utils")

M.options = {
	root_font_size = 16,
	decimal_count = 4,
	show_virtual_text = true,
	add_cmp_source = true,
	disable_keymaps = false,
	filetypes = {
		"css",
		"scss",
		"sass",
	},
}

M.setup = function(options)
	options = options or {}

	M.options = vim.tbl_deep_extend("keep", options, M.options)

	vim.api.nvim_create_user_command("PxToRemCursor", M.px_to_rem_at_cursor, {})
	vim.api.nvim_create_user_command("PxToRemLine", M.px_to_rem_on_line, {})

	if not M.options.disable_keymaps then
		vim.api.nvim_set_keymap("n", "<leader>px", ":PxToRemCursor<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>pxl", ":PxToRemLine<CR>", { noremap = true, silent = true })
	end

	if M.options.show_virtual_text then
		M.virtual_text()
	end

	if M.options.add_cmp_source then
		local cmp = require("cmp")

		if not cmp then
			return
		end

		local source = require("nvim-px-to-rem-cmp").add_to_cmp(
			M.options.root_font_size,
			M.options.decimal_count,
			M.options.filetypes
		)

		cmp.register_source("nvim_px_to_rem", source.new())
	end
	return M.options
end

M.virtual_text = function()
	M.namespace = vim.api.nvim_create_namespace("nvim-px-to-rem")

	-- Change filtype format from "*.css" to "css"
	local filetypes = {}
	for _, filetype in ipairs(M.options.filetypes) do
		table.insert(filetypes, "*" .. filetype)
	end

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "CursorMoved", "CursorMovedI" }, {
		pattern = filetypes,
		callback = function()
			M.px_to_rem()
		end,
	})
end

M.px_to_rem = function()
	-- Get current line content
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
	local virtual_text = {}

	for rem in line_content:gmatch("(-?%d+%.?%d*)rem") do
		local rem_size = tonumber(rem)
		local px_size = rem_size * M.options.root_font_size
		local pxrem = string.format("%spx", tostring(utils.round(px_size, M.options.decimal_count)))
		table.insert(virtual_text, pxrem)
	end

	-- Check if an extmark already exists
	local extmark = vim.api.nvim_buf_get_extmark_by_id(0, M.namespace, M.namespace, {})
	if extmark ~= nil then
		vim.api.nvim_buf_del_extmark(0, M.namespace, M.namespace)
	end

	if #virtual_text > 0 then
		vim.api.nvim_buf_set_extmark(
			0,
			tonumber(M.namespace),
			line - 1,
			0,
			{
				virt_text = { { table.concat(virtual_text, " "), "Comment" } },
				id = M.namespace,
				priority = 100,
			}
			-- { { table.concat(virtual_text, " "), "Comment" } }
		)
	end
end

M.px_to_rem_at_cursor = function()
	local regex = "%d+%.?%d*"

	local input = vim.fn.expand("<cWORD>")
	local px = string.match(input, regex)

	if px == nil then
		return
	end

	local px_size = tonumber(px)

	if px_size == nil then
		return
	end

	local rem_size = px_size / M.options.root_font_size
	local rem = string.format("%srem", tostring(utils.round(rem_size, M.options.decimal_count)))

	local rem_with_str = input:gsub(regex .. "px", rem)

	vim.cmd("normal! diW")
	local cursor_at_end = vim.fn.getpos(".")[3] + 1 == vim.fn.col("$")
	if cursor_at_end then
		vim.cmd("normal! a" .. rem_with_str)
	else
		vim.cmd("normal! i" .. rem_with_str)
	end
end

M.px_to_rem_on_line = function()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]

	for rem in line_content:gmatch("(-?%d+%.?%d*)px") do
		local rem_size = tonumber(rem)
		local px_size = rem_size / M.options.root_font_size
		local pxrem = string.format("%srem", tostring(utils.round(px_size, M.options.decimal_count)))

		local rem_with_str = line_content:gsub("(-?%d+%.?%d*)px", pxrem, 1)
		vim.api.nvim_buf_set_lines(0, line - 1, line, false, { rem_with_str })

		line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
	end
end
return M
