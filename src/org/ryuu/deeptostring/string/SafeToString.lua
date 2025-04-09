---
---tostring(self) maybe nil when override __tostring
---@param self any
---@return string
return function(self)
    local selfToString = tostring(self)
    if selfToString == nil then
        return "nil"
    end

    return selfToString
end
