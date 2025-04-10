package.path = package.path .. ";../src/org/ryuu/deeptostring/string/?.lua"
local deep_to_string = require "org.ryuu.deeptostring.deep_to_string"

describe("Deep to string Test Suite", function()
    it("handles primitive type conversions", function()
        -- Test nil type
        assert.equal("nil", deep_to_string(nil))

        -- Test boolean types
        assert.equal("true", deep_to_string(true))
        assert.equal("false", deep_to_string(false))

        -- Test number types
        assert.equal("123", deep_to_string(123))
        assert.equal("3.14", deep_to_string(3.14))

        -- Test string types (with escape)
        assert.equal("\'quote\"test\'", deep_to_string("\'quote\"test\'"))
    end)

    it("handles table structures", function()
        -- Empty table
        assert.matches("^table:0%x+$", deep_to_string({}))

        -- Array-like table
        assert.equal("{1, 2, 3}", deep_to_string({ 1, 2, 3 }))

        -- Key-value table
        local tbl = { a = 1, b = "test" }
        assert.equal([[{a = 1, b = "test"}]], deep_to_string(tbl))

        -- Nested table structure
        local nested = { x = { y = { z = 5 } } }
        assert.equal([[{x = {y = {z = 5}}}]], deep_to_string(nested))
    end)

    it("handles functions and userdata", function()
        -- Function type
        local func = function()
        end
        assert.matches("^function:0%+$", deep_to_string(func))

        -- Custom object (requires __tostring metamethod)
        local obj = setmetatable({}, { __tostring = function()
            return "MyObject"
        end })
        assert.equal("MyObject", deep_to_string(obj))
    end)

    it("handles edge cases", function()
        -- Cycle reference detection
        local cyclic = {}
        cyclic.self = cyclic
        assert.equal([[{self = <table>}]], deep_to_string(cyclic))

        -- Mixed-type table
        local mixed = {
            1,
            key = "value",
            func = function()
            end,
            sub = { a = true }
        }
        assert.matches([[{1, key = "value", func = function: 0%+, sub = {a = true}}]], deep_to_string(mixed))

        -- Error handling for unsupported types
        assert.has_error(function()
            deep_to_string(coroutine.create())
        end, "Unsupported type: thread")
    end)
end)
