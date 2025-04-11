local safe_to_string = require "org.ryuu.deeptostring.string.safe_to_string"

---
---@param self any
---@param prefix string
---@param suffix string
---@return string
return function(self, prefix, suffix)
    local string = safe_to_string(self)
    local match_string = string:match(prefix .. ".+" .. suffix)
    -- match_string may be nil if overwrite __tostring
    if match_string == nil then
        return string
    end

    return match_string
end
