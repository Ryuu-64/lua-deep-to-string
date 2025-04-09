require "InitializePackagePathForTests"

local DeepToString = require "org.ryuu.deeptostring.DeepToString"

local pairTable = DeepToString.Of({
    foo = "bar",
    bar = "foo"
})
print(pairTable)

local ipairTable = DeepToString.Of({
    "bar",
    "foo"
})
print(ipairTable)

local tableWithEmptyMetatable = DeepToString.Of(setmetatable({}, {}))
print(tableWithEmptyMetatable)

local tableWithMetatable = DeepToString.Of(setmetatable({}, {
    foo = 37,
    bar = 42,
    fooBar = function()
        print("foo bar")
    end
}))
print(tableWithMetatable)

local tableWithBoolean__metatable = DeepToString.Of(setmetatable({}, {
    __metatable = true
}))
print(tableWithBoolean__metatable)

local tableWithFunction__metatable = DeepToString.Of(setmetatable({}, {
    __metatable = function()
        print("tableWithFunction__metatable")
    end
}))
print(tableWithFunction__metatable)
