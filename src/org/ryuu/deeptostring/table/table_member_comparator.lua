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

return function(a, b)
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
