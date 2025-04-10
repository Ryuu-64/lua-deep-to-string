package.path = package.path .. ";../src/org/ryuu/deeptostring/string/?.lua"
local safe_to_string = require "org.ryuu.deeptostring.string.safe_to_string"

describe("Safe Tostring Function Test Suite", function()
    -- Primitive type handling
    it("handles primitive type conversions", function()
        assert.equal("nil", safe_to_string(nil))  -- Explicit nil handling
        assert.equal("42", safe_to_string(42))
        assert.equal("true", safe_to_string(true))
        assert.matches("function: 0%x+", safe_to_string(function()
        end))  -- Function pattern
    end)

    -- Metatable interaction tests
    describe("metatable behavior verification", function()
        it("processes valid __tostring returns", function()
            local obj = setmetatable({}, {
                __tostring = function()
                    return "ValidObject"
                end
            })
            assert.equal("ValidObject", safe_to_string(obj))  -- Normal metamethod
        end)

        local version_num = tonumber(string.match(_VERSION, "%d+%.%d+"))
        if version_num >= 5.4 then
            it("captures nil returns from __tostring", function()
                local obj = setmetatable({}, {
                    __tostring = function()
                        return nil
                    end
                })
                assert.has_error(function()
                    safe_to_string(obj)
                end, "'__tostring' must return a string")  -- Core functionality (in lua5.4 and after)
            end)
        else
            it("captures nil returns from __tostring", function()
                local obj = setmetatable({}, {
                    __tostring = function()
                        return nil
                    end
                })
                assert.equal("nil", safe_to_string(obj))  -- Core functionality
            end)
        end

        it("handles invalid __tostring types", function()
            local obj = setmetatable({}, {
                __tostring = "invalid_method"  -- Non-function metamethod
            })
            assert.has_error(function()
                safe_to_string(obj)  -- Expected type error
            end, "attempt to call a string value")
        end)
    end)

    -- Complex object scenarios
    it("handles cyclic table references", function()
        local cyclic = {}
        cyclic.self = cyclic  -- Cyclic reference
        assert.matches("table: 0%x+", safe_to_string(cyclic))  -- Default output
    end)

    -- Boundary conditions
    it("processes special value conversions", function()
        assert.equal("", safe_to_string(""))  -- Empty string
        assert.equal("false", safe_to_string(false))  -- Boolean conversion
        assert.equal("3.1415", safe_to_string(3.1415))  -- Float precision
    end)
end)
