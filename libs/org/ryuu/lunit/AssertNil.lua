local AssertionFailure = require "org.ryuu.lunit.AssertionFailure"

---
---@param actual any
---@param messageOrSupplier string|fun():string
return function(actual, messageOrSupplier)
    if actual == nil then
        return
    end

    AssertionFailure.Instantiate()
        :MessageOrSupplier(messageOrSupplier)
        :Expected("nil")
        :Actual(actual)
        :Error()
end
