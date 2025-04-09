---
---tostring(self) maybe nil when override __tostring
---@param self any
---@return string
return function(self)
    local string = tostring(self)
    if string == nil then
        return "nil"
    end

    return string
end
