--[[Play State
init player and map


]]--
PlayState = Class{__includes = BaseState}

function PlayState:init()
    -- You can initialize other PlayState variables here
    self.room = nil
    self.player = nil -- placeholder, add your player object later
end

function PlayState:enter(params)
    -- Create a room: width x height in tiles
    self.room = Room:new(20, 12)
end

function PlayState:update(dt)
end

function PlayState:render()
    -- Draw the room at top-left
    if self.room then
        self.room:render(0, 0, 16)
    end
end