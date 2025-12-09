PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player)
    self.entity = player
    self.entity.offsetY = 24
    self.entity.offsetX = 40
end

function PlayerWalkState:update(dt)

    -- gather input
    local dx, dy = 0, 0

    if love.keyboard.isDown('left')  then dx = dx - 1 end
    if love.keyboard.isDown('right') then dx = dx + 1 end
    if love.keyboard.isDown('up')    then dy = dy - 1 end
    if love.keyboard.isDown('down')  then dy = dy + 1 end

    local len = math.sqrt(dx*dx + dy*dy)

    -- dodge (pass raw dx/dy to PlayerDodgeState)
    if love.keyboard.wasPressed('space') then
        -- if not moving, dodge in direction player is facing
        if dx == 0 and dy == 0 then
            if self.entity.direction == 'up' then dy = -1
            elseif self.entity.direction == 'down' then dy = 1
            elseif self.entity.direction == 'left' then dx = -1
            elseif self.entity.direction == 'right' then dx = 1
            end
        end
        self.entity:changeState('dodge', { dx, dy})
        return
    end

    -- if no input → idle
    if len == 0 then
        self.entity:changeState('idle')
        return
    end

    -- normalize movement
    dx = dx / len
    dy = dy / len

    -- apply movement
    self.entity.x = self.entity.x + dx * self.entity.walkSpeed * dt
    self.entity.y = self.entity.y + dy * self.entity.walkSpeed * dt

    -- choose animation based on dominant axis
    if math.abs(dx) > math.abs(dy) then
        if dx < 0 then
            self.entity.direction = 'left'
            self.entity:changeAnimation('walk-left')
        else
            self.entity.direction = 'right'
            self.entity:changeAnimation('walk-right')
        end
    else
        if dy < 0 then
            self.entity.direction = 'up'
            self.entity:changeAnimation('walk-up')
        else
            self.entity.direction = 'down'
            self.entity:changeAnimation('walk-down')
        end
    end
end
