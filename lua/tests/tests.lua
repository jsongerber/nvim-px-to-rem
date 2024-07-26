local nvim_px_to_rem_cmp = require("nvim-px-to-rem-cmp")
local utils = require("utils")

describe("cursor_str", function()
	it("should match the pixel value", function()
		--                                                                    |11
		assert.equal("12px", utils.get_start_of_word_under_cursor("font-size: 12px;", 11)[1])
		--                                                                     |12
		assert.equal("12px", utils.get_start_of_word_under_cursor("font-size: 12px;", 12)[1])
		--                                                                      |13
		assert.equal("12px", utils.get_start_of_word_under_cursor("font-size: 12px;", 13)[1])
		--                                                                       |14
		assert.equal("12px", utils.get_start_of_word_under_cursor("font-size: 12px;", 14)[1])
		--                                                                        |12
		assert.equal("12.5px", utils.get_start_of_word_under_cursor("font-size: 12.5px;", 12)[1])
		--                                                                        |13
		assert.equal("12.5px", utils.get_start_of_word_under_cursor("font-size: 12.5px;", 13)[1])
		--                                                                         |14
		assert.equal("12.5px", utils.get_start_of_word_under_cursor("font-size: 12.5px;", 14)[1])
		--                                                                          |15
		assert.equal("12.5px", utils.get_start_of_word_under_cursor("font-size: 12.5px;", 15)[1])
		--                                                                           |16
		assert.equal("12.5px", utils.get_start_of_word_under_cursor("font-size: 12.5px;", 16)[1])
	end)
	it("should match nothing", function()
		--                                                               |10
		assert.equal("", utils.get_start_of_word_under_cursor("font-size: 12px;", 10)[1])
		--                                                                    |15
		assert.equal("", utils.get_start_of_word_under_cursor("font-size: 12px;", 15)[1])
		--                                                                            |17
		assert.equal("", utils.get_start_of_word_under_cursor("font-size: 12.5px;", 17)[1])
	end)
	it("should match other than px", function()
		--                                                            |7
		assert.equal("size", utils.get_start_of_word_under_cursor("font-size: 12px;", 7)[1])
	end)
end)

describe("utils", function()
	it("should round", function()
		assert.equal("1.281", tostring(utils.round("1.2813", 3)))
		assert.equal("12.5", tostring(utils.round("12.50006", 3)))
		assert.equal("20.501", tostring(utils.round("20.5008", 3)))
		assert.equal("20.5008", tostring(utils.round("20.5008", 4)))
	end)
end)

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
