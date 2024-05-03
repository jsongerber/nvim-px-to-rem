local nvim_px_to_rem_cmp = require("nvim-px-to-rem-cmp")

describe("cmp", function()
	it("should match every possiblity to write px value in css", function()
		local keyword_pattern = nvim_px_to_rem_cmp.get_keyword_pattern()
		local test_values = {
			"font-size: 16px",
			"font-size: 16.5px",
			"font-size: 16",
			"font-size: 16.5",
		}

		for _, value in ipairs(test_values) do
			local regexp = vim.regex(keyword_pattern)
			local s, e = regexp:match_str(value)
			assert.truthy(s)
		end
	end)
end)
