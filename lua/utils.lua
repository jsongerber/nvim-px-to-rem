local M = {}

M.round = function(number, decimals)
	local power = 10 ^ decimals
	return math.floor(number * power + 0.5) / power
end

return M
