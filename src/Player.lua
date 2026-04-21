--[[Player
Credit to Colton Ogden's CS50G work for the base structure and functions of this class
Defines the player and provides functions to support spell casting based on user input
Auto aim system for spells that targets nearest enemy within range and on screen, or in facing direction if no valid targets
]]--
Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    --Casting system. 3 inputs to cast with a 2 second timeout
    self.cast_buffer = {}
    self.cast_timer = 0
    self.cast_timeout = 2.0
    self.max_cast_inputs = 3
    self.pending_spell = nil
    self.windup = 0
    self.windup_timer = 0
end

function Player:update(dt)
    Entity.update(self, dt)
    self:updateCast(dt)

    --Separate update function for casting system to allow player to cast while moving/dodging
    if self.pending_spell then
        self.windup_timer = self.windup_timer + dt

        if self.windup_timer >= self.windup then
            if self.pending_spell.onCast then
                self.pending_spell.onCast(self)
            end

            self.pending_spell = nil
            self.windup = 0
            self.windup_timer = 0
        end
    end
end

function Player:updateCast(dt)
    if self.pending_spell then
        return
    end

    self.cast_timer = self.cast_timer + dt
    if self.cast_timer > self.cast_timeout then
        self.cast_buffer = {}
        self.cast_timer = 0
    end

    local pressed = nil
    if love.keyboard.wasPressed("up") then pressed = INPUT_UP
    elseif love.keyboard.wasPressed("down") then pressed = INPUT_DOWN
    elseif love.keyboard.wasPressed("left") then pressed = INPUT_LEFT
    elseif love.keyboard.wasPressed("right") then pressed = INPUT_RIGHT
    end

    if pressed then
        table.insert(self.cast_buffer, pressed)
        self.cast_timer = 0
    end

    if #self.cast_buffer == self.max_cast_inputs then
        local spell = self:matchSpell()

        self.cast_buffer = {}
        self.cast_timer = 0

        if spell then
            self.pending_spell = spell
            self.windup = spell.windup or 0
            self.windup_timer = 0
        end
    end
end


--Compare 3 input pattern with ATTACK_DEFS
function Player:matchSpell()
    for spellName, spell in pairs(ATTACK_DEFS) do
        if #spell.input == self.max_cast_inputs then
            if self.cast_buffer[1] == spell.input[1] and
               self.cast_buffer[2] == spell.input[2] and
               self.cast_buffer[3] == spell.input[3] then
                return spell
            end
        end
    end
    return nil
end

function Player:render()
    Entity.render(self)
end

--Rendering for casting system UI. Shows current inputs in buffer
function Player:renderCast()
    if self.pending_spell then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(gFonts['DefaultFont'])

        love.graphics.printf(
            "Casting",
            0,
            VIRTUAL_HEIGHT - 32,
            VIRTUAL_WIDTH,
            "center"
        )
    else
        if #self.cast_buffer == 0 then
            return
        end
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(gFonts['DefaultFont'])

        local text = table.concat(self.cast_buffer, " ")

        -- Draw near the bottom of the screen
        love.graphics.printf(
            "Cast: " .. text,
            0,
            VIRTUAL_HEIGHT - 32,
            VIRTUAL_WIDTH,
            "center"
        )
    end
end

--Spell auto aim system, gets unit vector to nearest target within range and on screen, or nil if no valid targets
function Player:playerGetNearestTargetVector(maxRange)
    if not self.room then return nil end

    local nearest = nil
    local nearest_dist = math.huge
    local center_x = self.x + (self.width or 0) / 2
    local center_y = self.y + (self.height or 0) / 2

    --Check all entities in the room for nearest valid target (not self, not dead)
    for _, e in ipairs(self.room.entities) do
        if e ~= self and not e.dead then
            --Check if target is visible on screen
            if self:targetOnScreen(e) then
                local target_x = e.x + (e.width or 0) / 2
                local target_y = e.y + (e.height or 0) / 2

                local vector_x = target_x - center_x
                local vector_y = target_y - center_y
                local len = math.sqrt(vector_x * vector_x + vector_y * vector_y)
                --Check spell range if maxRange provided, and if nearest target so far
                if (not maxRange or len <= maxRange) and len < nearest_dist then
                    nearest_dist = len
                    nearest = {vector_x = vector_x, vector_y = vector_y, target = e} --Unit vector to target and reference to target entity
                end
            end
        end
    end

    if not nearest then return nil end

    --Normalize vector to nearest target
    local len = math.sqrt(nearest.vector_x * nearest.vector_x + nearest.vector_y * nearest.vector_y)
    if len == 0 then return nil end

    return nearest.vector_x / len, nearest.vector_y / len, nearest.target
end

--Target on screen checking
function Player:targetOnScreen(target)
    --Get cam position for screen checking
    local cam_x, cam_y = gStateMachine.current:getCamera()
    local target_x = target.x - cam_x
    local target_y = target.y - cam_y
    local target_w = target.width
    local target_h = target.height

    local screen_width = VIRTUAL_WIDTH
    local screen_height = VIRTUAL_HEIGHT

    if target_x + target_w < 0 or target_x > screen_width or
       target_y + target_h < 0 or target_y > screen_height then
        return false
    end
    return true
end

--Special goInvulnerable for player to be adjustable
function Player:goInvulnerable()
    self.invulnerable = true
    self.invulnerable_duration = ENTITY_DEFS['player'].invulnerable_length
    self.invulnerable_timer = 0
end
