local FunctionDeepToString = require "org.ryuu.deeptostring.function.FunctionDeepToString"
local TableDeepToString = require "org.ryuu.deeptostring.table.TableDeepToString"

local DeepToString = {}

function DeepToString.Of(self)
    if self == nil then
        return "nil"
    end

    local selfType = type(self)
    if selfType == "table" then
        return TableDeepToString(self, 0, {})
    end

    if selfType == "function" then
        return FunctionDeepToString(self)
    end

    return tostring(self)
end

return DeepToString
