-- PlayerIdleState.lua
PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player)
    self.entity = player

    self.entity.offset_y = 24
    self.entity.offset_x = 40

    -- set idle animation based on facing direction
    self.entity:change_animation('idle-' .. self.entity.direction)
end

function PlayerIdleState:update(dt)
    self.dx, self.dy = 0, 0
    
    if love.keyboard.isDown(MOVE_UP) or
        love.keyboard.isDown(MOVE_DOWN) or
        love.keyboard.isDown(MOVE_LEFT) or
        love.keyboard.isDown(MOVE_RIGHT) then
        self.entity:change_state('walk')
        return
    end

    -- dodge from idle: compute vector and pass as params to dodge state
    if love.keyboard.wasPressed(DODGE) then
        local dx, dy = 0, 0
        if self.entity.direction == 'up' then dy = -1
        elseif self.entity.direction == 'down' then dy = 1
        elseif self.entity.direction == 'left' then dx = -1
        elseif self.entity.direction == 'right' then dx = 1
        end

        self.entity:change_state('dodge', { dx = dx, dy = dy })
    end
end
