-- Show px size of a given rem size in virtual text on current line

-- :s#:\\s\\?\\(\\d\\+\\)px#\\=": " . string(str2float(submatch(1)) / 16) . "rem"#g<CR>
do
	return
end
local M = {}

function M.init_pxrem()
	-- On cursor moved, show the px size of a given rem size in virtual text on current line

	vim.api.nvim_exec(
		[[
    augroup pxrem
      autocmd!
      autocmd CursorMoved * lua M.show_px()
    augroup END
  ]],
		false
	)
end

-- Show px size of a given rem size in virtual text on current line
function M.show_px()
	-- Clear other virtual text
	vim.api.nvim_buf_clear_namespace(0, 0, 0, -1)

	local line = vim.api.nvim_win_get_cursor(0)[1]
	local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
	local virtual_text = {}
	for rem in line_content:gmatch("(-?%d+.?%d*)rem") do
		local rem_size = tonumber(rem)
		local px_size = rem_size * 16
		local pxrem = string.format("%spx", tostring(px_size))
		table.insert(virtual_text, pxrem)
	end

	if #virtual_text > 0 then
		vim.api.nvim_buf_set_extmark(0, 0, line - 1, { { table.concat(virtual_text, " "), "Comment" } }, {})
	end
end

vim.api.nvim_create_augroup("pxrem", { clear = true })
vim.api.nvim_create_autocmd("CursorMoved", {
	group = "pxrem",
	pattern = "*",
	callback = M.show_px,
})

return M
