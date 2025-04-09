---
---@param self fun:any
---@return string
return function(self)
    local functionToString = tostring(self)
    return functionToString:match("function: (.+)")
end
