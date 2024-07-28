local AssertionFailure = require "org.ryuu.lunit.AssertionFailure"

---
---@param condition boolean
---@param messageOrSupplier string
return function(condition, messageOrSupplier)
    if condition then
        return
    end
    
    AssertionFailure.Instantiate()
        :MessageOrSupplier(messageOrSupplier)
        :Expected(true)
        :Actual(false)
        :Error()
end
