local AssertionFailure = require "org.ryuu.lunit.AssertionFailure"

---
---@param errorFunction fun(any:any):any
return function(errorFunction, messageOrSupplier)
    local typeOfErrorFunction = type(errorFunction)
    if typeOfErrorFunction ~= "function" then
        local cause = string.format(
            "expected type: <function> but was: <%s>",
            typeOfErrorFunction
        )
        AssertionFailure.Instantiate()
            :MessageOrSupplier(messageOrSupplier)
            :Cause(cause)
            :Error()
    end

    local status, _ = pcall(errorFunction)
    if not status then
        return
    end

    AssertionFailure.Instantiate()
        :MessageOrSupplier(messageOrSupplier)
        :Reason("expected an error, but no error was produced")
        :Error()
end
