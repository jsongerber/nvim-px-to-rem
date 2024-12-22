local nvim_px_to_rem_cmp = require("nvim-px-to-rem.integrations.cmp")
local utils = require("nvim-px-to-rem.utils")

describe("cursor_str", function()
	it("should match the pixel value", function()
		local input
		--                                                            |11
		input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12px;", 11)
		assert.equal("12px", input)
		--                                                             |12
		input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12px;", 12)
		assert.equal("12px", input)
		--                                                              |13
		input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12px;", 13)
		assert.equal("12px", input)
		--                                                               |14
		input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12px;", 14)
		assert.equal("12px", input)
		--                                                                  |15
		input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12.5px;", 15)
		assert.equal("12.5px", input)
		--                                                                   |16
		input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12.5px;", 16)
		assert.equal("12.5px", input)
	end)

	it("should match nothing", function()
		local input
		--                                                            |10
		input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12px;", 10)
		assert.equal("", input)
		--                                                                 |15
		input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12px;", 15)
		assert.equal("", input)
		--                                                                   |17
		input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12.5px;", 17)
		assert.equal("", input)
	end)

	it("should not match other than px", function()
		--                                                               |7
		local input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12px;", 7)
		assert.equal("", input)
	end)

	it("should not match other units", function()
		--                                                                    |12
		local input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12rem;", 12)
		assert.equal("", input)
		--                                                                    |12
		local input, _, _ = utils.get_start_of_word_under_cursor("font-size: 12em;", 12)
		assert.equal("", input)
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
			local s, _ = regexp:match_str(value)
			assert.truthy(s)
		end
	end)
end)
