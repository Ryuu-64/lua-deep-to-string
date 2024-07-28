local AssertionFailure = require "org.ryuu.lunit.AssertionFailure"

---
---@param condition boolean
---@param messageOrSupplier string
return function(condition, messageOrSupplier)
    if not condition then
        return
    end

    AssertionFailure.Instantiate()
        :MessageOrSupplier(messageOrSupplier)
        :Expected(false)
        :Actual(true)
        :Error()
end
