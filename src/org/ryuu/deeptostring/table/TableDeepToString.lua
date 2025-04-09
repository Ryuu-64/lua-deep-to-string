local TableMemberComparator = require "org.ryuu.deeptostring.table.TableMemberComparator"
local SafeToString = require "org.ryuu.deeptostring.string.SafeToString"
local GetLineCount = require "org.ryuu.deeptostring.string.GetLineCount"
local GetTableAddressString = require "org.ryuu.deeptostring.table.GetTableAddressString"
local FunctionDeepToString = require "org.ryuu.deeptostring.function.FunctionDeepToString"

local function GetSortedTableMembers(self)
    local members = {}
    for k, v in pairs(self) do
        table.insert(members, { field = k, value = v })
    end
    table.sort(members, TableMemberComparator)
    return members
end

local function TryGetExistMember(self, variable)
    for i = 1, #self do
        local member = self[i]
        if variable == member.value then
            return member
        end
    end

    return nil
end

local function TableToStringWithoutSpace(self)
    return "table:" .. GetTableAddressString(self)
end

local function NestedTableMemberDeepToString(value, member)
    return ": " .. TableToStringWithoutSpace(value) .. " <nested in:" .. tostring(member.field) .. ">\n"
end

local function TableMemberDeepToString(field, value, indent, TableDeepToString, existMembers)
    local member = TryGetExistMember(existMembers, value)
    if member == nil then
        table.insert(existMembers, { field = field, value = value })
        return TableDeepToString(value, indent, existMembers)
    end

    return NestedTableMemberDeepToString(value, member)
end

local function OtherMemberDeepToString(self, field, value)
    local toString = ": "
    if field == "__index" and self == value then
        toString = toString .. "<self reference>"
    else
        toString = toString .. tostring(value)
    end
    toString = toString .. "\n"
    return toString
end

local function MembersDeepToString(self, indent, TableDeepToString, existMembers)
    local toString = ""
    local members = GetSortedTableMembers(self)
    for i = 1, #members do
        local member = members[i]
        local field = member.field
        local value = member.value
        local typeOfValue = type(value)
        toString = toString .. string.rep(" ", indent) .. tostring(field)
        if typeOfValue == "table" and value ~= self then
            toString = toString .. TableMemberDeepToString(
                field, value,
                indent, TableDeepToString, existMembers
            )
        elseif typeOfValue == "function" then
            toString = toString .. ": " .. FunctionDeepToString(value) .. "\n"
        else
            toString = toString .. OtherMemberDeepToString(self, field, value)
        end
    end
    return toString
end

local function MetaTableDeepToString(self, indent, TableDeepToString, existMembers)
    local toString = ""
    local selfMetatable = getmetatable(self)
    if selfMetatable == nil then
        return toString
    end

    if type(selfMetatable) ~= "table" then
        if type(selfMetatable) == "function" then
            return string.rep(" ", indent) .. "metatable: " .. FunctionDeepToString(selfMetatable)
        else
            return string.rep(" ", indent) .. "metatable: " .. SafeToString(selfMetatable) .. "\n"
        end
    end

    toString = toString .. string.rep(" ", indent)

    local metatableToString = TableDeepToString(selfMetatable, indent, existMembers)
    local lineCount = GetLineCount(metatableToString)
    --endregion

    if lineCount == 1 then
        toString = toString .. "metatable: "
    else
        toString = toString .. "metatable:"
    end

    if selfMetatable == self then
        toString = toString .. " <self reference>"
        return toString
    end

    toString = toString .. metatableToString
    return toString
end

local function SelfDeepToString(self)
    return "(" .. TableToStringWithoutSpace(self) .. ")"
end

local function TableDeepToString(self, indent, existMembers)
    table.insert(existMembers, { field = "self", value = self })
    local membersToString = MembersDeepToString(
        self, indent + 2, TableDeepToString,
        existMembers
    )
    local metatableToString = MetaTableDeepToString(
        self, indent + 2, TableDeepToString, existMembers
    )
    local tableDeepToString = ""
    local selfToString = SelfDeepToString(self)
    tableDeepToString = tableDeepToString .. selfToString

    if membersToString ~= "" or metatableToString ~= "" then
        tableDeepToString = tableDeepToString .. ":"
    end
    tableDeepToString = tableDeepToString .. "\n"
    tableDeepToString = tableDeepToString .. membersToString .. metatableToString
    return tableDeepToString
end

return TableDeepToString
