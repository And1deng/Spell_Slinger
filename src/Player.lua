Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    --Casting system. 3 inputs to cast with a 2 second timeout
    self.cast_buffer = {}
    self.cast_timer = 0
    self.cast_timeout = 2.0
    self.max_cast_inputs = 3
end

function Player:update(dt)
    Entity.update(self, dt)
    --Separate update function for casting system to allow player to cast while moving/dodging
    self:update_cast(dt)
end

function Player:update_cast(dt)
    -- Clear cast cache based on timer
    self.cast_timer = self.cast_timer + dt
    if self.cast_timer > self.cast_timeout then
        self.cast_buffer = {}
        self.cast_timer = 0
    end

    local pressed = nil
    if love.keyboard.wasPressed("up") then pressed = "up"
    elseif love.keyboard.wasPressed("down") then pressed = "down"
    elseif love.keyboard.wasPressed("left") then pressed = "left"
    elseif love.keyboard.wasPressed("right") then pressed = "right"
    end

    --reset cast timer since player is still active
    if pressed then
        table.insert(self.cast_buffer, pressed)
        self.cast_timer = 0
    end

    --Once 3 inputs added, check attack_definitions.lua for match
    if #self.cast_buffer == self.max_cast_inputs then
        local spell = self:match_spell()
        
        if spell then
            if spell.on_cast then
                spell.on_cast(self)
            end
            --Reset buffer after cast
            self.cast_buffer = {}
            self.cast_timer = 0
        else
            --No match, clear buffer + reset timer
            self.cast_buffer = {}
            self.cast_timer = 0
        end
    end
end

--Compare 3 input pattern with ATTACK_DEFS
function Player:match_spell()
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
function Player:render_cast()
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

--Spell auto aim system, gets unit vector to nearest target within range and on screen, or nil if no valid targets
function Player:get_nearest_target_vector(maxRange)
    if not self.room then return nil end

    local nearest = nil
    local nearest_dist = math.huge
    local center_x = self.x + (self.width or 0) / 2
    local center_y = self.y + (self.height or 0) / 2

    --Check all entities in the room for nearest valid target (not self, not dead)
    for _, e in ipairs(self.room.entities) do
        if e ~= self and not e.dead then
            --Check if target is visible on screen
            if self:target_on_screen(e) then
                local target_x = e.x + (e.width or 0) / 2
                local target_y = e.y + (e.height or 0) / 2

                local dx = target_x - center_x
                local dy = target_y - center_y
                local d = math.sqrt(dx * dx + dy * dy)
                --Check spell range if maxRange provided, and if nearest target so far
                if (not maxRange or d <= maxRange) and d < nearest_dist then
                    nearest_dist = d
                    nearest = {dx = dx, dy = dy, target = e} --unit vector to target and reference to target entity
                end
            end
        end
    end

    if not nearest then return nil end

    --Normalize vector to nearest target
    local len = math.sqrt(nearest.dx * nearest.dx + nearest.dy * nearest.dy)
    if len == 0 then return nil end

    return nearest.dx / len, nearest.dy / len, nearest.target
end

--target on screen checking
function Player:target_on_screen(target)
    --Get cam position for screen checking
    local camx, camy = gStateMachine.current:get_camera()
    local target_x = target.x - camx
    local target_y = target.y - camy
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