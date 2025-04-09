local table_member_comparator = require "org.ryuu.deeptostring.table.table_member_comparator"
local safe_to_string = require "org.ryuu.deeptostring.string.safe_to_string"
local line_count = require "org.ryuu.deeptostring.string.line_count"
local table_address_to_string = require "org.ryuu.deeptostring.table.table_address_to_string"
local function_deep_to_string = require "org.ryuu.deeptostring.function.function_deep_to_string"

local function GetSortedTableMembers(self)
    local members = {}
    for k, v in pairs(self) do
        table.insert(members, { field = k, value = v })
    end
    table.sort(members, table_member_comparator)
    return members
end

local function try_get_exist_member(self, variable)
    for i = 1, #self do
        local member = self[i]
        if variable == member.value then
            return member
        end
    end

    return nil
end

local function table_to_string_without_space(self)
    return "table:" .. table_address_to_string(self)
end

local function table_self_to_string_without_space(self)
    return "(" .. table_to_string_without_space(self) .. ")"
end

local function nested_table_member_deep_to_string(value, member)
    return table_self_to_string_without_space(value) .. " # nested in:" .. safe_to_string(member.field) .. "\n"
end

local function other_member_deep_to_string(self, field, value)
    local toString = ": "
    if field == "__index" and self == value then
        toString = toString .. "<self reference>"
    else
        toString = toString .. safe_to_string(value)
    end
    toString = toString .. "\n"
    return toString
end

local table_deep_to_string

local function table_member_deep_to_string(field, value, indent, exist_members)
    local member = try_get_exist_member(exist_members, value)
    if member == nil then
        table.insert(exist_members, { field = field, value = value })
        return table_deep_to_string(value, indent, exist_members)
    end

    return nested_table_member_deep_to_string(value, member)
end

local function members_deep_to_string(self, indent, exist_members)
    local to_string = ""
    local members = GetSortedTableMembers(self)
    for i = 1, #members do
        local member = members[i]
        local field = member.field
        local value = member.value
        local value_type = type(value)
        to_string = to_string .. string.rep(" ", indent) .. safe_to_string(field)
        if value_type == "table" then
            to_string = to_string .. ": " .. table_member_deep_to_string(field, value, indent, exist_members)
        elseif value_type == "function" then
            to_string = to_string .. ": " .. function_deep_to_string(value) .. "\n"
        else
            to_string = to_string .. other_member_deep_to_string(self, field, value)
        end
    end
    return to_string
end

local function metatable_deep_to_string(self, indent, exist_members)
    local toString = ""
    local self_metatable = getmetatable(self)
    if self_metatable == nil then
        return toString
    end

    if type(self_metatable) ~= "table" then
        if type(self_metatable) == "function" then
            return string.rep(" ", indent) .. "metatable: " .. function_deep_to_string(self_metatable)
        else
            return string.rep(" ", indent) .. "metatable: " .. safe_to_string(self_metatable) .. "\n"
        end
    end

    toString = toString .. string.rep(" ", indent)

    local metatableToString = table_deep_to_string(self_metatable, indent, exist_members)
    local lineCount = line_count(metatableToString)
    --endregion

    if lineCount == 1 then
        toString = toString .. "metatable: "
    else
        toString = toString .. "metatable:"
    end

    if self_metatable == self then
        toString = toString .. " <self reference>"
        return toString
    end

    toString = toString .. metatableToString
    return toString
end

table_deep_to_string = function(self, indent, exist_members)
    table.insert(exist_members, { field = "self", value = self })

    local final_string = ""
    local self_string = table_self_to_string_without_space(self)
    final_string = final_string .. self_string
    local members_string = members_deep_to_string(
            self, indent + 2, exist_members
    )
    local metatable_string = metatable_deep_to_string(
            self, indent + 2, exist_members
    )
    if members_string ~= "" or metatable_string ~= "" then
        final_string = final_string .. ":"
    end
    final_string = final_string .. "\n"
    final_string = final_string .. members_string .. metatable_string
    return final_string
end

return table_deep_to_string
