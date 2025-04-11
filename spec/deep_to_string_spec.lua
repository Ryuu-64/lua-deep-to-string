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
        print(deep_to_string({}))

        -- Array like table
        print(deep_to_string({ 1, 2, 3 }))

        -- Key value table
        print(deep_to_string({ a = 1, b = "test" }))

        -- Nested table structure
        print(deep_to_string({ x = { y = { z = 5 } } }))

        -- Cycle reference detection
        local cyclic = {}
        cyclic.self = cyclic
        print(deep_to_string(cyclic))

        -- Mixed type table
        local mixed_type_table = {
            1,
            key = "value",
            func = function()
            end,
            sub = { a = true }
        }
        print(deep_to_string(mixed_type_table))
    end)

    it("handle empty metatable", function()
        local table = {}
        local metatable = {}
        setmetatable(table, metatable)
        print(deep_to_string(table))
    end)

    it("handles functions", function()
        -- Function type
        print(deep_to_string(function()
        end))

        -- Custom object (requires __tostring meta method)
        local table = {}
        local metatable = {
            __tostring = function()
                return "MyObject"
            end
        }
        setmetatable(table, metatable)
        print(deep_to_string(table))
    end)

    it("handles coroutine", function()
        print(deep_to_string(coroutine.create(function()
        end)))
    end)
end)
