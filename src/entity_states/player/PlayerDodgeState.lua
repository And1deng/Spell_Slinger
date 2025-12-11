-- PlayerDodgeState.lua
PlayerDodgeState = Class{__includes = EntityWalkState}

function PlayerDodgeState:init(player)
    self.entity = player

    self.entity.offsetY = 24
    self.entity.offsetX = 40

    -- Dodge movement config
    self.dodgeDistance = 50
    self.dodgeSpeed = 400
    self.dodgeTimer = 0
    self.dodgeDuration = self.dodgeDistance / self.dodgeSpeed

    -- default vector
    self.dx = 0
    self.dy = 0
end

function PlayerDodgeState:enter(params)
    self.dodgeTimer = 0

    local dx, dy = 0, 0
    if params and params.dx and params.dy then
        dx = params.dx
        dy = params.dy
    else
        if love.keyboard.isDown(MOVE_LEFT)  then dx = dx - 1 end
        if love.keyboard.isDown(MOVE_RIGHT) then dx = dx + 1 end
        if love.keyboard.isDown(MOVE_UP)    then dy = dy - 1 end
        if love.keyboard.isDown(MOVE_DOWN)  then dy = dy + 1 end
        if dx == 0 and dy == 0 then
            if self.entity.direction == 'up' then dy = -1
            elseif self.entity.direction == 'down' then dy = 1
            elseif self.entity.direction == 'left' then dx = -1
            elseif self.entity.direction == 'right' then dx = 1
            end
        end
    end

    local len = math.sqrt(dx * dx + dy * dy)
    if len > 0 then
        self.dx = dx / len
        self.dy = dy / len
    else
        self.dx = 0
        self.dy = 0
    end
end

function PlayerDodgeState:update(dt)
    self.entity.invulnerable = true
    self.dodgeTimer = self.dodgeTimer + dt

    -- movement along vector
    local moveAmount = self.dodgeSpeed * dt
    self.entity.x = self.entity.x + self.dx * moveAmount
    self.entity.y = self.entity.y + self.dy * moveAmount

    -- pick animation based on direction
    if math.abs(self.dx) > math.abs(self.dy) then
        if self.dx < 0 then
            self.entity:changeAnimation('walk-left')
        else
            self.entity:changeAnimation('walk-right')
        end
    else
        if self.dy < 0 then
            self.entity:changeAnimation('walk-up')
        else
            self.entity:changeAnimation('walk-down')
        end
    end

    -- end dodge
    if self.dodgeTimer >= self.dodgeDuration then
        self.entity.invulnerable = false

        if love.keyboard.isDown(MOVE_UP) or
            love.keyboard.isDown(MOVE_DOWN) or
            love.keyboard.isDown(MOVE_LEFT) or
            love.keyboard.isDown(MOVE_RIGHT) then
            self.entity:changeState('walk')
        else
            self.entity:changeState('idle')
        end
    end
end
