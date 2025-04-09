﻿local GetFunctionAddressString = require "org.ryuu.deeptostring.function.GetFunctionAddressString"

---
---@param self fun:any
---@return string
return function(self)
    local info = debug.getinfo(self, "uS")
    local paramLength = info.nparams
    local isVarArg = info.isvararg
    local params = {}
    for i = 1, paramLength do
        table.insert(params, "param" .. i)
    end

    if isVarArg then
        table.insert(params, "...")
    end

    local paramsString = table.concat(params, ", ")
    local addressString = GetFunctionAddressString(self)
    return string.format("function(%s) %s", paramsString, addressString)
end
