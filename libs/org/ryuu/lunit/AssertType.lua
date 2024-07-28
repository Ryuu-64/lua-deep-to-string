local AssertionFailure = require "org.ryuu.lunit.AssertionFailure"

local typeStrings = {
    ["nil"] = true,
    ["number"] = true,
    ["string"] = true,
    ["boolean"] = true,
    ["table"] = true,
    ["function"] = true,
    ["thread"] = true,
    ["userdata"] = true
}

local function Is(value)
    if type(value) ~= "string" then
        return false
    end

    if typeStrings[value] == nil then
        return false
    end

    return true
end

return function(expected, actual, messageOrSupplier)
    --region try error if expected or actual is not type
    local causes = {}
    if not Is(expected) then
        table.insert(causes, string.format("invalid expected: <%s>", tostring(expected)))
    end
    if not Is(actual) then
        table.insert(causes, string.format("invalid actual: <%s>", tostring(actual)))
    end
    if #causes ~= 0 then
        table.insert(causes, "expected and actual should be type string return by type()")
        AssertionFailure.Instantiate()
            :MessageOrSupplier(messageOrSupplier)
            :Cause(table.concat(causes, ", "))
            :Error()
    end
    --endregion

    if expected == actual then
        return
    end

    AssertionFailure.Instantiate()
        :MessageOrSupplier(messageOrSupplier)
        :IsExpected(true)
        :Expected(expected)
        :Actual(actual)
        :Error()
end
