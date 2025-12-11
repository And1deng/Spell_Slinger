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
        local speed = self.entity.walkSpeed or 30
        
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
        
        local minX, maxX = 20, VIRTUAL_WIDTH - 20 - self.entity.width
        local minY, maxY = 20, VIRTUAL_HEIGHT - 20 - self.entity.height
        
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

function EntityWalkState:processAI(params, dt)
    local room = params and params.room or self.room
    local directions = {'left', 'right', 'up', 'down'}
    
    if self.moveDuration == 0 or self.bumped then
        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0
        
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end
    
    self.movementTimer = self.movementTimer + dt
end

function EntityWalkState:render() 
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end