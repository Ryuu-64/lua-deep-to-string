local safe_to_string = require "org.ryuu.deeptostring.string.safe_to_string"
local table_deep_to_string = require "org.ryuu.deeptostring.table.table_deep_to_string"

return function(self)
    if self == nil then
        return "nil"
    end

    if type(self) == "table" then
        return table_deep_to_string(self, 0, {})
    end

    return safe_to_string(self)
end
