-- PlayerIdleState.lua
PlayerIdleState = Class{__includes = EntityIdleState}


function PlayerIdleState:enter(player)
    self.entity.offsetY = 24
    self.entity.offsetX = 40

    self.entity:changeAnimation('idle-' .. self.entity.direction)
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('up', 'down', 'left', 'right') then
        self.entity:changeState('walk')
    end
end
