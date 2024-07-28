local AssertionFailure = require "org.ryuu.lunit.AssertionFailure"

---
---@param value table
local function TableToString(value)
    local toString = "{"

    local kvStrings = {}
    for k, v in pairs(value) do
        local kvString = string.format("%s = %s", tostring(k), tostring(v))
        table.insert(kvStrings, kvString)
    end
    toString = toString .. table.concat(kvStrings, ", ")
    toString = toString .. "}"
    return toString
end

return function(expected, actual, messageOrSupplier)
    --region type error
    local causes = {}
    local typeOfExpected = type(expected)
    if typeOfExpected ~= "table" then
        table.insert(causes, string.format("invalid expected type: <%s>", typeOfExpected))
    end

    local typeOfActual = type(actual)
    if typeOfActual ~= "table" then
        table.insert(causes, string.format("invalid actual type: <%s>", typeOfActual))
    end

    if #causes ~= 0 then
        table.insert(causes, "expected and actual should be table type")
        AssertionFailure.Instantiate()
            :MessageOrSupplier(messageOrSupplier)
            :Cause(table.concat(causes, ", "))
            :Error()
    end
    --endregion

    if expected == actual then
        return
    end

    if #actual ~= #expected then
        local reason = string.format(
            "lengths differ, expected: <%d> but was: <%d>",
            #expected, #actual
        )
        AssertionFailure.Instantiate()
            :MessageOrSupplier(messageOrSupplier)
            :Expected(expected)
            :Actual(actual)
            :Reason(reason)
            :Error()
    end

    local isEqual = true
    for actualKey, actualValue in pairs(actual) do
        local expectedValue = expected[actualKey]
        if actualValue ~= expectedValue then
            isEqual = false
            break
        end
    end

    if isEqual then
        return
    end

    local reason = string.format(
        "expected: <%s> but was: <%s>",
        TableToString(expected), TableToString(actual)
    )
    AssertionFailure.Instantiate()
        :MessageOrSupplier(messageOrSupplier)
        :Expected(expected)
        :Actual(actual)
        :Reason(reason)
        :Error()
end
