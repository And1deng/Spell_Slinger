EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, room)
    self.entity = entity
    -- self.entity:changeAnimation('walk-down')  -- Commented out for now
    
    self.room = room

    self.moveDuration = 0
    self.movementTimer = 0
    
    self.bumped = false
end

function EntityWalkState:update(dt)
    self.bumped = false
    
    if self.entity.direction then
        local speed = self.entity.walk_speed
        
        local newX, newY = self.entity.x, self.entity.y
        
        if self.entity.direction == 'left' then
            newX = newX - speed * dt
        elseif self.entity.direction == 'right' then
            newX = newX + speed * dt
        elseif self.entity.direction == 'up' then
            newY = newY - speed * dt
        elseif self.entity.direction == 'down' then
            newY = newY + speed * dt
        end
        
-- Clamp to room/world bounds (not the virtual screen size)
        local roomWidthPixels = (self.entity.room and self.entity.room.width * TILE_SIZE) or VIRTUAL_WIDTH
        local roomHeightPixels = (self.entity.room and self.entity.room.height * TILE_SIZE) or VIRTUAL_HEIGHT

        local minX, maxX = 20, roomWidthPixels - 20 - self.entity.width
        local minY, maxY = 20, roomHeightPixels - 20 - self.entity.height
        
        if newX < minX then
            newX = minX
            self.bumped = true
        elseif newX > maxX then
            newX = maxX
            self.bumped = true
        end
        
        if newY < minY then
            newY = minY
            self.bumped = true
        elseif newY > maxY then
            newY = maxY
            self.bumped = true
        end
        
        self.entity.x, self.entity.y = newX, newY
    end
end