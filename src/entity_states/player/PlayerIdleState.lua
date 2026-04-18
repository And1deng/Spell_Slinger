--[[PlayerIdleState
Idle until a movement key is pressed (MOVE + DODGE inputs determined in constants.lua)
Dodge in current facing direction if DODGE is pressed, even without movement input
]]--
PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player)
    self.entity = player

    self.entity.offset_x = ENTITY_DEFS['player'].offset_x
    self.entity.offset_y = ENTITY_DEFS['player'].offset_y
end

function PlayerIdleState:enter()
    self.entity:changeAnimation('idle_' .. self.entity.direction)
end

function PlayerIdleState:update(dt)
    self.entity.dx, self.entity.dy = 0, 0   
    
    if love.keyboard.isDown(MOVE_UP) or
        love.keyboard.isDown(MOVE_DOWN) or
        love.keyboard.isDown(MOVE_LEFT) or
        love.keyboard.isDown(MOVE_RIGHT) then
        self.entity:changeState('walk')
        return
    end

    if love.keyboard.wasPressed(DODGE) then
        local vector_x, vector_y = 0, 0
        if self.entity.direction == 'up' then vector_y = -1
        elseif self.entity.direction == 'down' then vector_y = 1
        elseif self.entity.direction == 'left' then vector_x = -1
        elseif self.entity.direction == 'right' then vector_x = 1
        end

        self.entity:changeState('dodge', { vector_x = vector_x, vector_y = vector_y })
    end
end
