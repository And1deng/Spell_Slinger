-- PlayerIdleState.lua
PlayerIdleState = Class{__includes = EntityIdleState}


function PlayerIdleState:enter(player)
    --place sprite render offsets here
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('up', 'down', 'left', 'right') then
        self.entity:changeState('walk')
    end
end
