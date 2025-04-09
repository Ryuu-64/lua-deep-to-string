---
---@param self string
---@return number
return function(self)
    local count = 0
    for _ in string.gmatch(self, "[^\r\n]+") do
        count = count + 1
    end
    return count
end
