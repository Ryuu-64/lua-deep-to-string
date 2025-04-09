---
---@param self table
---@return string
return function(self)
    local tableToString = tostring(self)
    return tableToString:match("table: (.+)")
end
