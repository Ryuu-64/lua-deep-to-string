local AssertionFailure = require "org.ryuu.lunit.AssertionFailure"

return function(expected, actual, messageOrSupplier)
    if rawequal(expected, actual) then
        return
    end

    AssertionFailure.Instantiate()
        :MessageOrSupplier(messageOrSupplier)
        :Expected(expected)
        :Actual(actual)
        :Error()
end
