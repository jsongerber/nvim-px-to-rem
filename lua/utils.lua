local M = {}

--- Round number to the specified number of decimals
---@param number string Number to be rounded
---@param decimals number Number of decimals
---@return number
M.round = function(number, decimals)
	local power = 10 ^ decimals
	return math.floor(number * power + 0.5) / power
end

--- Get the index of the start of the cWORD under cursor
---@param line_content string
---@param col number
---@return table: The word, start and end index
M.get_start_of_word_under_cursor = function(line_content, col)
	local word = ""
	local forward = col + 1
	local backward = col
	local forwardbreak = false
	local backwardbreak = false

	local i = 0
	while true do
		i = i + 1

		if not forwardbreak then
			local forwardchar = line_content:sub(forward, forward)
			-- Use \k that is a vim atom pattern for keyword
			if forwardbreak or nil == forwardchar:match("[a-zA-Z0-9.px]") then
				forwardbreak = true

				-- If the first character is not a word character, then break
				if i == 1 then
					backwardbreak = true
				end
			else
				word = word .. forwardchar
				forward = forward + 1
			end
		end

		if not backwardbreak then
			local backwardchar = line_content:sub(backward, backward)
			if backwardbreak or nil == backwardchar:match("[a-zA-Z0-9.px]") then
				backwardbreak = true
			else
				word = backwardchar .. word
				backward = backward - 1
			end
		end

		if forwardbreak and backwardbreak then
			break
		end
	end

	return { word, backward, forward - 1 }
end

return M
