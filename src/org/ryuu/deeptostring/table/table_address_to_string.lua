local address_to_string = require "org.ryuu.deeptostring.string.address_to_string"

---
---@param self table
---@return string
return function(self)
    return address_to_string(self, "table: (", ")")
end
