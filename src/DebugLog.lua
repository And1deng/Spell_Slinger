--[[DebugLog
Simple logging utility for debugging different features and functions
Not very consistent as I only added it to a few places, but can be expanded as needed
]]--

local debug_log = {}

function debug_log.log(fmt, ...)
    if not DEBUG_MODE then 
        return
    end

    local ok, msg = pcall(string.format, fmt, ...)
    
    if not ok then 
        msg = tostring(fmt) 
    end

    print(msg)

    -- append to file in project's working dir
    local f, err = io.open('debug.log', 'a')
    if f then
        f:write(os.date('%Y-%m-%d %H:%M:%S') .. ' ' .. msg .. '\n')
        f:close()
    end
end

return debug_log
