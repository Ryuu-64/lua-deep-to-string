local AssertionFailure = require "org.ryuu.lunit.AssertionFailure"

return function(unexpected, actual, messageOrSupplier)
    if not rawequal(unexpected, actual) then
        return
    end

    AssertionFailure.Instantiate()
        :MessageOrSupplier(messageOrSupplier)
        :IsExpected(false)
        :Expected(unexpected)
        :Actual(actual)
        :Error()
end
