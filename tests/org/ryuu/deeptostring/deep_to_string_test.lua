require "initialize"

local deep_to_string = require "org.ryuu.deeptostring.deep_to_string"

local pair_table = deep_to_string({
    foo = "bar",
    bar = "foo"
})
print(pair_table)

local ipair_table = deep_to_string({
    "bar",
    "foo"
})
print(ipair_table)

local function_table = deep_to_string({
    function(foo, bar)
        print(foo + bar)
    end
})
print(function_table)

local nested_table = {}
nested_table.foo = nested_table
local nested_table_to_string = deep_to_string(nested_table)
print(nested_table_to_string)

local table_member_table = {}
table_member_table.foo = {}
local nested_member_table_to_string = deep_to_string(table_member_table)
print(nested_member_table_to_string)

local table_nested = { { {} } }
local table_nested_string = deep_to_string(table_nested)
print(table_nested_string)

--region metatable
local table_with_empty_metatable = deep_to_string(setmetatable({}, {}))
print(table_with_empty_metatable)

local table_with_metatable = deep_to_string(setmetatable({}, {
    foo = 37,
    bar = 42,
    fooBar = function()
        print("foo bar")
    end
}))
print(table_with_metatable)

local table_with_boolean_metatable = deep_to_string(setmetatable({}, {
    __metatable = true
}))
print(table_with_boolean_metatable)

local table_with_function_metatable = deep_to_string(setmetatable({}, {
    __metatable = function()
        print("table_with_function_metatable")
    end
}))
print(table_with_function_metatable)

local table_with_self_metatable = {}
local table_with_self_metatable_string = deep_to_string(setmetatable(table_with_self_metatable, table_with_self_metatable))
print(table_with_self_metatable_string)

local table_with__index = {}
table_with__index.__index = {
    foo = 37,
    bar = 42,
    fooBar = function()
        print("foo bar")
    end
}
local table_with__index_string = deep_to_string(table_with__index)
print(table_with__index_string)

local table_with__index_self = {}
table_with__index_self.__index = table_with__index_self
local table_with__index_self_string = deep_to_string(table_with__index_self)
print(table_with__index_self_string)
--endregion
