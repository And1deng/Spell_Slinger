--[[PlayerDodgeState
Player dodge based on config in entity_definitions.lua
PlayerDodgeState is entered from PlayerIdleState or PlayerWalkState when DODGE input is detected, so params should always be passed 
]]--
PlayerDodgeState = Class{__includes = EntityWalkState}

function PlayerDodgeState:init(player)
    self.entity = player

    self.entity.offset_x = ENTITY_DEFS['player'].offset_x
    self.entity.offset_y = ENTITY_DEFS['player'].offset_y

    self.dodge_distance = ENTITY_DEFS['player'].dodge_distance
    self.dodge_speed = ENTITY_DEFS['player'].dodge_speed
    self.dodge_timer = 0
    self.entity.invulnerable_timer = 0
    self.entity.invulnerable_duration = self.dodge_distance / self.dodge_speed

    self.direction_x = 0
    self.direction_y = 0
end

function PlayerDodgeState:enter(params)
    self.dodge_timer = 0
    self.entity.invulnerable = true
    self.entity.invulnerable_timer = 0
    local vector_x, vector_y = 0, 0

    if params then
        vector_x = params.vector_x or 0
        vector_y = params.vector_y or 0
    end

    local len = math.sqrt(vector_x * vector_x + vector_y * vector_y)
    if len > 0 then
        self.direction_x = vector_x / len
        self.direction_y = vector_y / len
    end
end


function PlayerDodgeState:update(dt)
    --invulnerability handled in Player:update, here we just track dodge movement and timer to return to normal state at end of dodge
    self.dodge_timer = self.dodge_timer + dt
    local moveAmount = self.dodge_speed * dt

    --Check movement with collision to prevent moving through walls during dodge, but allow movement through enemies still
    self.entity.room:moveEntity(self.entity, self.direction_x * moveAmount, self.direction_y * moveAmount)

    --No dodge animation in sprite sheet so I use the walk animation for now
    if math.abs(self.direction_x) > math.abs(self.direction_y) then
        if self.direction_x < 0 then
            self.entity:changeAnimation('walk_left')
        else
            self.entity:changeAnimation('walk_right')
        end
    else
        if self.direction_y < 0 then
            self.entity:changeAnimation('walk_up')
        else
            self.entity:changeAnimation('walk_down')
        end
    end

    --At end of dodge, return to idle or walk depending on if there is movement input
    if self.dodge_timer >= self.dodge_distance / self.dodge_speed then
        if love.keyboard.isDown(MOVE_UP) or
            love.keyboard.isDown(MOVE_DOWN) or
            love.keyboard.isDown(MOVE_LEFT) or
            love.keyboard.isDown(MOVE_RIGHT) then
            self.entity.invulnerable = false
            self.entity:changeState('walk')
        else
            self.entity.invulnerable = false
            self.entity:changeState('idle')
        end
    end
end
