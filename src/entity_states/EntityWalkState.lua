--[[EntityWalkState
Base walking state for all entities
Check for direction and move entity accordingly, using room's moveEntity function to handle collisions
]]--

EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, room)
    self.entity = entity
    
    self.room = room

    self.move_duration = 0
    self.movement_timer = 0
end

function EntityWalkState:enter()
    if self.entity.direction then
        self.entity:changeAnimation('walk_' .. self.entity.direction)
    end
end

function EntityWalkState:update(dt)
    if self.entity.direction then
        self.entity:changeAnimation('walk_' .. self.entity.direction)

        local speed = self.entity.walk_speed
        local dx, dy = 0, 0

        if self.entity.direction == 'left' then
            dx = -speed * dt
        elseif self.entity.direction == 'right' then
            dx = speed * dt
        elseif self.entity.direction == 'up' then
            dy = -speed * dt
        elseif self.entity.direction == 'down' then
            dy = speed * dt
        end

        local room = self.entity.room or self.room
        if room and room.moveEntity then
            room:moveEntity(self.entity, dx, dy)
        end
    end
end
