---
---@class AssertionFailure
---@field messageOrSupplier string|fun():string user-defined message or supplier of the assertion
---@field cause string
---@field reason string when not nil, reason will not generate by actual and expected
---@field isExpected boolean true when expected, false when not expected
---@field expected any may be unexpected when assert not, in this case the isExpected is false
---@field actual any
local AssertionFailure = {}
AssertionFailure.__index = AssertionFailure

---
---@return AssertionFailure
function AssertionFailure.Instantiate()
    ---@type AssertionFailure
    local instance = {}
    setmetatable(instance, AssertionFailure)
    instance.messageOrSupplier = nil
    instance.cause = nil
    instance.reason = nil
    instance.isExpected = true
    instance.expected = nil
    instance.actual = nil
    return instance
end

function AssertionFailure:MessageOrSupplier(messageOrSupplier)
    self.messageOrSupplier = messageOrSupplier
    return self
end

function AssertionFailure:Reason(reason)
    self.reason = reason
    return self
end

function AssertionFailure:Cause(cause)
    self.cause = cause
    return self
end

function AssertionFailure:IsExpected(isExpected)
    self.isExpected = isExpected
    return self
end

function AssertionFailure:Expected(expected)
    self.expected = expected
    return self
end

function AssertionFailure:Actual(actual)
    self.actual = actual
    return self
end

local function MessageString(messageOrSupplier)
    if type(messageOrSupplier) == "function" then
        return messageOrSupplier()
    end

    return tostring(messageOrSupplier)
end

local function ReasonString(expected, actual, isExpected)
    local formatString
    if isExpected then
        formatString = "expected: <%s> but was: <%s>"
    else
        formatString = "expected not: <%s> but was: <%s>"
    end

    return string.format(
        formatString,
        tostring(expected),
        tostring(actual)
    )
end

local function CauseString(cause)
    return tostring(cause)
end

function AssertionFailure:Error()
    local errorMessages = {}

    local messageString = MessageString(self.messageOrSupplier)
    if messageString ~= "nil" then
        table.insert(errorMessages, string.format("message: %s", messageString))
    end

    local causeString = CauseString(self.cause)
    if causeString ~= "nil" then
        table.insert(errorMessages, string.format("cause: %s", causeString))
        error(table.concat(errorMessages, ", "))
    end

    if self.reason == nil then
        local reasonString = ReasonString(self.expected, self.actual, self.isExpected)
        if reasonString ~= "nil" then
            table.insert(errorMessages, string.format("reason: %s", reasonString))
        end
    else
        table.insert(errorMessages, string.format("reason: %s", self.reason))
    end

    local errorMessage = table.concat(errorMessages, ", ")
    error(errorMessage)
end

return AssertionFailure
