--[[PlayerDeathState
]]--
PlayerDeathState = Class{__includes = EntityDeathState}

function PlayerDeathState:init(player)
    EntityDeathState.init(self, player)
end

function PlayerDeathState:enter(params)
    EntityDeathState.enter(self, params)
end

function PlayerDeathState:update(dt)
end
