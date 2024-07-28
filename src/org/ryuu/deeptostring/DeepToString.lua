local DeepToString = {}
local indentSpaceCount = 2
local EXIST_TABLE_MEMBERS = {}

function DeepToString.SetIndentSpaceCount(count)
    indentSpaceCount = count
end

local function FunctionDeepToString(self)
    local info = debug.getinfo(self, "uS")
    local paramLength = info.nparams
    local isVarArg = info.isvararg
    local params = {}
    for i = 1, paramLength do
        table.insert(params, "param" .. i)
    end
    if isVarArg then
        table.insert(params, "...")
    end

    return string.format("function(%s) %s", table.concat(params, ", "), tostring(self):match("function: (.+)"))
end

--region table
local function GetTypePriority(value)
    local valueType = type(value)
    if valueType == "userdata" then
        return 4
    end

    if valueType == "function" then
        return 3
    end

    if valueType == "table" then
        return 2
    end

    return 1
end

local function TableMemberComparator(a, b)
    local priorityA = GetTypePriority(a.value)
    local priorityB = GetTypePriority(b.value)

    if priorityA ~= priorityB then
        return priorityA < priorityB
    end

    local typeAField = type(a.field)
    local typeBField = type(b.field)
    if typeAField ~= typeBField then
        priorityA = GetTypePriority(a.field)
        priorityB = GetTypePriority(b.field)
        if priorityA ~= priorityB then
            return priorityA < priorityB
        end
        return false
    end

    if typeAField == "userdata" or typeBField == "userdata" then
        return false
    elseif typeAField == "table" or typeBField == "table" then
        return false
    else
        return a.field < b.field
    end
end

---tostring(self) maybe nil when override __tostring
local function SafeToString(self)
    local selfToString = tostring(self)
    if selfToString == nil then
        return "nil"
    end

    return selfToString
end

local function YamlSafeToString(self)
    local selfToString = SafeToString(self)
    selfToString = string.gsub(selfToString, "table: ", "table:")
    return selfToString
end

local function GetSortedTableMembers(self)
    local members = {}
    for k, v in pairs(self) do
        table.insert(members, { field = k, value = v })
    end
    table.sort(members, TableMemberComparator)
    return members
end

local function TryGetExistMember(variable)
    for i = 1, #EXIST_TABLE_MEMBERS do
        local member = EXIST_TABLE_MEMBERS[i]
        if variable == member.value then
            return member
        end
    end

    return nil
end

local function InternalTableDeepToString(field, value, indent, TableDeepToString)
    local existMember = TryGetExistMember(value)
    if existMember == nil then
        table.insert(EXIST_TABLE_MEMBERS, { field = field, value = value })
        return TableDeepToString(value, indent)
    end

    return ": " .. YamlSafeToString(value) .. " <nested in:" .. tostring(existMember.field) .. ">\n"
end

local function OtherDeepToString(self, field, value)
    local toString = ": "
    if field == "__index" and self == value then
        toString = toString .. "<self reference>"
    else
        toString = toString .. tostring(value)
    end
    toString = toString .. "\n"
    return toString
end

local function TableMetaTableDeepToString(self, indent, TableDeepToString)
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

    toString = toString .. string.rep(" ", indent) .. "metatable:"

    if selfMetatable == self then
        toString = toString .. " <self reference>"
        return toString
    end

    toString = toString .. TableDeepToString(selfMetatable, indent)
    return toString
end

local function TableSelfDeepToString(self, membersToString, metatableToString)
    local toString = ""
    toString = toString .. "(" .. YamlSafeToString(self) .. ")"
    if membersToString ~= "" or metatableToString ~= "" then
        toString = toString .. ":"
    end
    toString = toString .. "\n"
    return toString
end

local function TableMembersDeepToString(self, indent, TableDeepToString)
    local toString = ""
    local members = GetSortedTableMembers(self)
    for i = 1, #members do
        local member = members[i]
        local field = member.field
        local value = member.value
        local valueType = type(value)
        toString = toString .. string.rep(" ", indent) .. tostring(field)
        if valueType == "table" and value ~= self then
            toString = toString .. InternalTableDeepToString(field, value, indent, TableDeepToString)
        elseif valueType == "function" then
            toString = toString .. ": " .. FunctionDeepToString(value) .. "\n"
        else
            toString = toString .. OtherDeepToString(self, field, value)
        end
    end
    return toString
end

local function TableDeepToString(self, indent)
    table.insert(EXIST_TABLE_MEMBERS, { field = "self", value = self })
    local membersToString = TableMembersDeepToString(self, indent + indentSpaceCount, TableDeepToString)
    local metatableToString = TableMetaTableDeepToString(self, indent + indentSpaceCount, TableDeepToString)
    local selfToString = TableSelfDeepToString(self, membersToString, metatableToString)
    return selfToString .. membersToString .. metatableToString
end
--endregion

function DeepToString.Of(self)
    if self == nil then
        return "nil"
    end

    local selfType = type(self)
    if selfType == "table" then
        EXIST_TABLE_MEMBERS = {}
        return TableDeepToString(self, 0)
    end

    if selfType == "function" then
        return FunctionDeepToString(self)
    end

    return tostring(self)
end

return DeepToString
