-- PlayerIdleState.lua
PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player)
    self.entity = player

    self.entity.offsetY = 24
    self.entity.offsetX = 40

    -- set idle animation based on facing direction
    self.entity:changeAnimation('idle-' .. self.entity.direction)
end

function PlayerIdleState:update(dt)
    self.dx, self.dy = 0, 0
    
    if love.keyboard.isDown('up') or
       love.keyboard.isDown('down') or
       love.keyboard.isDown('left') or
       love.keyboard.isDown('right') then
        self.entity:changeState('walk')
        return
    end

    -- dodge from idle: compute vector and pass as params to dodge state
    if love.keyboard.wasPressed('space') then
        local dx, dy = 0, 0
        if self.entity.direction == 'up' then dy = -1
        elseif self.entity.direction == 'down' then dy = 1
        elseif self.entity.direction == 'left' then dx = -1
        elseif self.entity.direction == 'right' then dx = 1
        end

        self.entity:changeState('dodge', { dx = dx, dy = dy })
    end
end
