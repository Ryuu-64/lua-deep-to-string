local AssertTrue = require "org.ryuu.lunit.AssertTrue"
local AssertFalse = require "org.ryuu.lunit.AssertFalse"
local AssertNil = require "org.ryuu.lunit.AssertNil"
local AssertNotNil = require "org.ryuu.lunit.AssertNotNil"
local AssertEqual = require "org.ryuu.lunit.AssertEqual"
local AssertNotEqual = require "org.ryuu.lunit.AssertNotEqual"
local AssertRawEqual = require "org.ryuu.lunit.AssertRawEqual"
local AssertNotRawEqual = require "org.ryuu.lunit.AssertNotRawEqual"
local AssertType = require "org.ryuu.lunit.AssertType"
local AssertError = require "org.ryuu.lunit.AssertError"
local AssertTableEqual = require "org.ryuu.lunit.AssertTableEqual"

---@class Assertions
local Assertions = {}

local results = {}

function Assertions.AssertEqual(expected, actual, messageOrSupplier)
    local status, error = pcall(AssertEqual, expected, actual, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

function Assertions.AssertNotEqual(unexpected, actual, messageOrSupplier)
    local status, error = pcall(AssertNotEqual, unexpected, actual, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

function Assertions.AssertRawEqual(expected, actual, messageOrSupplier)
    local status, error = pcall(AssertRawEqual, expected, actual, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

function Assertions.AssertNotRawEqual(unexpected, actual, messageOrSupplier)
    local status, error = pcall(AssertNotRawEqual, unexpected, actual, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

function Assertions.AssertTrue(condition, messageOrSupplier)
    local status, error = pcall(AssertTrue, condition, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

function Assertions.AssertFalse(condition, messageOrSupplier)
    local status, error = pcall(AssertFalse, condition, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

function Assertions.AssertNil(actual, messageOrSupplier)
    local status, error = pcall(AssertNil, actual, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

function Assertions.AssertNotNil(actual, messageOrSupplier)
    local status, error = pcall(AssertNotNil, actual, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

function Assertions.AssertType(expected, actual, messageOrSupplier)
    local status, error = pcall(AssertType, expected, actual, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

function Assertions.AssertError(errorFunction, messageOrSupplier)
    local status, error = pcall(AssertError, errorFunction, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

function Assertions.AssertTableEqual(expected, actual, messageOrSupplier)
    local status, error = pcall(AssertTableEqual, expected, actual, messageOrSupplier)
    table.insert(results, { status = status, error = error })
    return status, error
end

local function AnalyzeResults()
    local totalCount = #results
    local failedCount = 0
    local errorMessages = {}

    for _, result in ipairs(results) do
        if not result.status then
            failedCount = failedCount + 1
            table.insert(errorMessages, result.error)
        end
    end

    return totalCount, failedCount, errorMessages
end

local function GetResultString(totalCount, failedCount)
    if totalCount == 1 then
        return string.format("%d test completed, %d failed", totalCount, failedCount)
    end

    return string.format("%d tests completed, %d failed", totalCount, failedCount)
end

local function ConcatenateErrorMessages(errorMessages)
    local errorMessage = ""
    for i, msg in ipairs(errorMessages) do
        errorMessage = errorMessage .. "\n" .. i .. ". " .. msg
    end
    return errorMessage
end

function Assertions.Result()
    local totalCount, failedCount, errorMessages = AnalyzeResults()
    results = {}

    local resultString = GetResultString(totalCount, failedCount)
    if failedCount == 0 then
        print(resultString)
        return
    end

    local errorMessage = ConcatenateErrorMessages(errorMessages)
    error(resultString .. errorMessage)
end

return Assertions
