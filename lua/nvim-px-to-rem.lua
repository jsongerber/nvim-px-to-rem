local M = {}

M.options = {
	root_font_size = 16,
	decimal_count = 4,
	show_virtual_text = true,
	add_cmp_source = true,
	filetypes = {
		"css",
		"scss",
		"sass",
	},
}

M.setup = function(options)
	options = options or {}

	M.options = vim.tbl_deep_extend("keep", options, M.options)

	vim.api.nvim_create_user_command("PxToRemCursor", function()
		vim.api.nvim_feedkeys(M.px_to_rem_at_cursor(), "n", false)
	end, {})
	vim.api.nvim_create_user_command("PxToRemLine", function()
		vim.api.nvim_feedkeys(M.px_to_rem_on_line(), "n", false)
	end, {})

	if M.options.disable_keymaps ~= nil then
		vim.notify(
			"nvim-px-to-rem: Keymaps aren't defined anymore, you can remove the `disable_keymaps` option and set you owns (see README.md)",
			vim.log.levels.WARN
		)
	end

	if M.options.show_virtual_text then
		M.virtual_text()
	end

	if M.options.add_cmp_source then
		-- Only load cmp when we enter insert mode
		vim.api.nvim_create_autocmd({ "InsertEnter" }, {
			once = true,
			pattern = vim.tbl_map(function(filetype)
				return "*" .. filetype
			end, M.options.filetypes),
			callback = function(args)
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
				vim.api.nvim_del_autocmd(args.id)
			end,
		})
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
	local utils = require("utils")

	for rem in line_content:gmatch("(-?%d+%.?%d*)rem") do
		local rem_size = tonumber(rem)
		local px_size = rem_size * M.options.root_font_size
		local pxrem = string.format("%spx", tostring(utils.round(tostring(px_size), M.options.decimal_count)))
		table.insert(virtual_text, pxrem)
	end

	-- Check if an extmark already exists
	local extmark = vim.api.nvim_buf_get_extmark_by_id(0, M.namespace, M.namespace, {})
	if extmark ~= nil then
		vim.api.nvim_buf_del_extmark(0, M.namespace, M.namespace)
	end

	local ns_id = tonumber(M.namespace)
	if #virtual_text > 0 and ns_id ~= nil then
		vim.api.nvim_buf_set_extmark(
			0,
			ns_id,
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
	vim.go.operatorfunc = "v:lua.require'nvim-px-to-rem'.dot_px_to_rem_at_cursor"
	return "g@l"
end

M.dot_px_to_rem_at_cursor = function()
	local regex = "%d+%.?%d*"
	local utils = require("utils")

	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
	local input, word_start, word_end = unpack(utils.get_start_of_word_under_cursor(line_content, col))
	if input == nil then
		vim.notify("No px value found", vim.log.levels.WARN)
		return
	end

	local px = string.match(input, regex)

	if px == nil then
		vim.notify("No px value found", vim.log.levels.WARN)
		return
	end

	local px_size = tonumber(px)

	if px_size == nil then
		vim.notify("No px value found", vim.log.levels.WARN)
		return
	end

	local rem_size = px_size / M.options.root_font_size
	local rem = string.format("%srem", tostring(utils.round(tostring(rem_size), M.options.decimal_count)))

	vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_end, { rem })
end

M.px_to_rem_on_line = function()
	vim.go.operatorfunc = "v:lua.require'nvim-px-to-rem'.dot_px_to_rem_on_line"
	return "g@l"
end

M.dot_px_to_rem_on_line = function()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
	local new_line = line_content
	local utils = require("utils")

	for rem in line_content:gmatch("(-?%d+%.?%d*)px") do
		local rem_size = tonumber(rem)
		local px_size = rem_size / M.options.root_font_size
		local pxrem = string.format("%srem", tostring(utils.round(tostring(px_size), M.options.decimal_count)))

		new_line = new_line:gsub("(-?%d+%.?%d*)px", pxrem, 1)
	end

	vim.api.nvim_buf_set_lines(0, line - 1, line, false, { new_line })
end

return M
