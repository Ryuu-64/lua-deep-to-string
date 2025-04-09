local safe_to_string = require "org.ryuu.deeptostring.string.safe_to_string"

---
---@param self table
---@return string
return function(self)
    local string = safe_to_string(self)
    return string:match("table: (.+)")
end
