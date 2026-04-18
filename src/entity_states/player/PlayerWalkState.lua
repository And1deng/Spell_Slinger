--[[PlayerWalkState
Move player based on MOVE + DODGE inputs determined in constants.lua, normalized for diagonal movement
Dodge option has priority over the walk
]]--
PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player)
    self.entity = player
    self.entity.offset_x = ENTITY_DEFS['player'].offset_x
    self.entity.offset_y = ENTITY_DEFS['player'].offset_y
end

function PlayerWalkState:update(dt)
    local vector_x, vector_y = 0, 0

    --Allows for opposite directions to be cancelled out
    if love.keyboard.isDown(MOVE_LEFT)  then vector_x = vector_x - 1 end
    if love.keyboard.isDown(MOVE_RIGHT) then vector_x = vector_x + 1 end

    if love.keyboard.isDown(MOVE_UP)    then vector_y = vector_y - 1 end
    if love.keyboard.isDown(MOVE_DOWN)  then vector_y = vector_y + 1 end

    local normalizedLen = math.sqrt(vector_x*vector_x + vector_y*vector_y)

    if love.keyboard.wasPressed(DODGE) then
        --Default to direction in case there is no deciding vector to dodge in
        if vector_x == 0 and vector_y == 0 then
            if self.entity.direction == 'up' then vector_y = -1
            elseif self.entity.direction == 'down' then vector_y = 1
            elseif self.entity.direction == 'left' then vector_x = -1
            elseif self.entity.direction == 'right' then vector_x = 1
            end
        end
        self.entity:changeState('dodge', { vector_x = vector_x, vector_y = vector_y })
    end

    if normalizedLen == 0 then
        self.entity:changeState('idle')
        return
    else
        vector_x = vector_x / normalizedLen
        vector_y = vector_y / normalizedLen
    end

    --Whichever vector is most dominant determines general "direction" of the player and animation
    if math.abs(vector_x) > math.abs(vector_y) then
        if vector_x < 0 then
            self.entity.direction = 'left'
            self.entity:changeAnimation('walk_left')
        else
            self.entity.direction = 'right'
            self.entity:changeAnimation('walk_right')
        end
    else
        if vector_y < 0 then
            self.entity.direction = 'up'
            self.entity:changeAnimation('walk_up')
        else
            self.entity.direction = 'down'
            self.entity:changeAnimation('walk_down')
        end
    end

    --Movement passed to room for collision resolution
    self.entity.room:moveEntity(self.entity, vector_x * self.entity.walk_speed * dt, vector_y * self.entity.walk_speed * dt)
end
