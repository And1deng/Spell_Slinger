-- PlayerWalkState.lua
PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player)
    self.entity = player
end

function PlayerWalkState:update(dt)
    local isMoving = false

    -- WASD / arrow keys
    if love.keyboard.isDown('up') then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt
        self.entity.direction = 'up'
        isMoving = true
    elseif love.keyboard.isDown('down') then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt
        self.entity.direction = 'down'
        isMoving = true
    end

    if love.keyboard.isDown('left') then
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt
        self.entity.direction = 'left'
        isMoving = true
    elseif love.keyboard.isDown('right') then
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt
        self.entity.direction = 'right'
        isMoving = true
    end

    -- If no movement, go back to idle
    if not isMoving then
        self.entity:changeState('idle')
    end
end
