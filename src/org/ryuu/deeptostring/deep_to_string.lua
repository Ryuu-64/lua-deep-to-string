local safe_to_string = require "org.ryuu.deeptostring.string.safe_to_string"
local function_deep_to_string = require "org.ryuu.deeptostring.function.function_deep_to_string"
local table_deep_to_string = require "org.ryuu.deeptostring.table.table_deep_to_string"

return function(self)
    if self == nil then
        return "nil"
    end

    local selfType = type(self)
    if selfType == "table" then
        return table_deep_to_string(self, 0, {}) .. "\n"
    end

    if selfType == "function" then
        return function_deep_to_string(self) .. "\n"
    end

    return safe_to_string(self)
end
