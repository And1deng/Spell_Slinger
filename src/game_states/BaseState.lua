--[[Base State Class
Credit to CS50's intro to game development course.
States will inherit from this
]]--

BaseState = Class{}

function BaseState:init()
end

function BaseState:enter(params)
end

function BaseState:exit()
end

function BaseState:update(dt)
end

function BaseState:render()
end

