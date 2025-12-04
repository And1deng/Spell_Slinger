EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, room)
    self.entity = entity
    -- self.entity:changeAnimation('walk-down')  -- Commented out for now
    
    self.room = room  -- Changed from dungeon to room
    
    -- used for AI control (for enemies)
    self.moveDuration = 0
    self.movementTimer = 0
    
    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function EntityWalkState:update(dt)
    -- For player control, we'll handle direction in PlayerWalkState
    -- This base method will handle movement based on self.entity.direction
    
    -- assume we didn't hit a wall
    self.bumped = false
    
    -- Only move if we have a direction set
    if self.entity.direction then
        -- Get movement speed
        local speed = self.entity.walkSpeed or 30
        
        -- Calculate new position
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
        
        -- Basic boundary checking (adjust these constants as needed)
        local minX, maxX = 20, VIRTUAL_WIDTH - 20 - self.entity.width
        local minY, maxY = 20, VIRTUAL_HEIGHT - 20 - self.entity.height
        
        -- Check boundaries
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
        
        -- Update position
        self.entity.x, self.entity.y = newX, newY
    end
end

function EntityWalkState:processAI(params, dt)
    -- This is for AI enemies, not players
    -- You can keep it as is for enemy AI
    
    local room = params and params.room or self.room
    local directions = {'left', 'right', 'up', 'down'}
    
    if self.moveDuration == 0 or self.bumped then
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
        -- self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0
        
        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            -- self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end
    
    self.movementTimer = self.movementTimer + dt
end

function EntityWalkState:render()
    -- Basic rectangle render for now
    love.graphics.setColor(0, 1, 0, 1)  -- Green for walking
    love.graphics.rectangle('fill', self.entity.x, self.entity.y, 
                           self.entity.width, self.entity.height)
    love.graphics.setColor(1, 1, 1, 1)
    
    -- If you had animations:
    -- local anim = self.entity.currentAnimation
    -- love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
    --     math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end