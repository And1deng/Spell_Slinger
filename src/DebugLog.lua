local DebugLog = {}

DebugLog.enabled = true

function DebugLog.log(fmt, ...)
    if not DebugLog.enabled then return end

    local ok, msg = pcall(string.format, fmt, ...)
    if not ok then msg = tostring(fmt) end

    -- write to console as before
    print(msg)

    -- append to file in project's working dir
    local f, err = io.open('debug.log', 'a')
    if f then
        f:write(os.date('%Y-%m-%d %H:%M:%S') .. ' ' .. msg .. '\n')
        f:close()
    end
end

return DebugLog
