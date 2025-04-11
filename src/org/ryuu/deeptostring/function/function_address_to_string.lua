local address_to_string = require "org.ryuu.deeptostring.string.address_to_string"

---
---@param self fun:any
---@return string
return function(self)
    return address_to_string(self, "function: (", ")")
end
