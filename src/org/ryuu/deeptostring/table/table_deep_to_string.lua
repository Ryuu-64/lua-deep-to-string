local table_member_comparator = require "org.ryuu.deeptostring.table.table_member_comparator"
local safe_to_string = require "org.ryuu.deeptostring.string.safe_to_string"
local get_line_count = require "org.ryuu.deeptostring.string.get_line_count"
local table_address_to_string = require "org.ryuu.deeptostring.table.table_address_to_string"
local function_deep_to_string = require "org.ryuu.deeptostring.function.function_deep_to_string"

local function get_sorted_table_members(self)
    local members = {}
    for k, v in pairs(self) do
        table.insert(members, { field = k, value = v })
    end
    table.sort(members, table_member_comparator)
    return members
end

local function try_get_exist_member(self, members)
    for i = 1, #self do
        local member = self[i]
        if members == member.value then
            return member
        end
    end

    return nil
end

local function table_to_string_without_space(self)
    return "table:" .. table_address_to_string(self)
end

local function nested_table_member_deep_to_string(value, member)
    return table_to_string_without_space(value) .. " # nested in \"" .. safe_to_string(member.field) .. "\""
end

local table_deep_to_string

local function table_member_deep_to_string(field, value, indent, exist_members, self)
    if self == value then
        return table_to_string_without_space(self) .. " # self reference"
    end

    local member = try_get_exist_member(exist_members, value)
    if member ~= nil then
        return nested_table_member_deep_to_string(value, member)
    end

    table.insert(exist_members, { field = field, value = value })
    return table_deep_to_string(value, indent, exist_members, true)
end

local function members_deep_to_string(self, indent, exist_members)
    local members = get_sorted_table_members(self)
    local member_string_list = {}
    for i = 1, #members do
        local member = members[i]
        local field = member.field
        local value = member.value
        local value_type = type(value)
        local member_string = string.rep(" ", indent) .. safe_to_string(field)
        if value_type == "table" then
            local table_member_string = table_member_deep_to_string(field, value, indent, exist_members, self)
            member_string = member_string .. ":"
            local line_count = get_line_count(table_member_string)
            if line_count == 1 then
                member_string = member_string .. " "
            end
            member_string = member_string .. table_member_string
        elseif value_type == "function" then
            member_string = member_string .. ": " .. function_deep_to_string(value)
        else
            member_string = member_string .. ": " .. safe_to_string(value)
        end
        table.insert(member_string_list, member_string)
    end
    return table.concat(member_string_list, "\n")
end

local function metatable_deep_to_string(self, indent, exist_members)
    local metatable = getmetatable(self)
    if metatable == nil then
        return ""
    elseif metatable == self then
        return string.rep(" ", indent) .. "metatable: " .. table_to_string_without_space(self) .. " # self reference"
    end

    if type(metatable) ~= "table" then
        if type(metatable) == "function" then
            return string.rep(" ", indent) .. "metatable: " .. function_deep_to_string(metatable)
        else
            return string.rep(" ", indent) .. "metatable: " .. safe_to_string(metatable)
        end
    end

    local to_string = string.rep(" ", indent)
    local metatable_string = table_deep_to_string(metatable, indent, exist_members, true)
    local line_count = get_line_count(metatable_string)
    to_string = to_string .. "metatable:"
    if line_count == 1 then
        to_string = to_string .. " "
    end

    to_string = to_string .. metatable_string
    return to_string
end

table_deep_to_string = function(self, indent, exist_members, has_parent)
    table.insert(exist_members, { field = "self", value = self })

    local final_string = ""
    local members_string = members_deep_to_string(
            self, indent + 2, exist_members
    )
    local metatable_string = metatable_deep_to_string(
            self, indent + 2, exist_members
    )
    local members_string_line_count = get_line_count(members_string)
    local metatable_string_line_count = get_line_count(metatable_string)

    if members_string_line_count + metatable_string_line_count == 0 then
        if has_parent == true then
            return table_to_string_without_space(self)
        end

        return safe_to_string(self)
    end

    final_string = final_string .. table_to_string_without_space(self)
    final_string = final_string .. ":"
    if members_string ~= "" then
        final_string = final_string .. "\n" .. members_string
    end
    if metatable_string ~= "" then
        final_string = final_string .. "\n" .. metatable_string
    end
    return final_string
end

return table_deep_to_string
