Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    -- Casting system
    self.cast_buffer = {}
    self.cast_timer = 0
    self.cast_timeout = 2.0
    self.max_cast_inputs = 3
end

function Player:update(dt)
    -- Normal entity + state update
    Entity.update(self, dt)

    -- Casting update (runs independently of movement states)
    self:update_cast(dt)
end

function Player:update_cast(dt)
    -- Advance timer and clear cast if stale
    self.cast_timer = self.cast_timer + dt
    if self.cast_timer > self.cast_timeout then
        self.cast_buffer = {}
        self.cast_timer = 0
    end

    -- Handle new directional input
    local pressed = nil
    if love.keyboard.wasPressed("up") then pressed = "up"
    elseif love.keyboard.wasPressed("down") then pressed = "down"
    elseif love.keyboard.wasPressed("left") then pressed = "left"
    elseif love.keyboard.wasPressed("right") then pressed = "right"
    end

    if pressed then
        table.insert(self.cast_buffer, pressed)
        self.cast_timer = 0   -- reset since an input was added
    end

    -- Check for max inputs → try cast spell
    if #self.cast_buffer == self.max_cast_inputs then
        local spell = self:match_spell()
        
        if spell then
            if spell.on_fire then
                spell.on_fire(self)
            end
            -- Reset buffer after cast
            self.cast_buffer = {}
            self.cast_timer = 0
        else
            -- Slide buffer window forward (like fighting game input buffer)
            table.remove(self.cast_buffer, 1)
        end
    end
end

-- Compare buffer with ATTACK_DEFS
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

-- Render player normally + cast overlay UI
function Player:render()
    Entity.render(self)
end

function Player:render_cast()
    if #self.cast_buffer == 0 then
        return
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['DefaultFont'])

    local text = table.concat(self.cast_buffer, " ")

    -- Draw at the bottom of the screen
    love.graphics.printf(
        "Cast: " .. text,
        0,
        VIRTUAL_HEIGHT - 32,
        VIRTUAL_WIDTH,
        "center"
    )
end

-- Return normalized direction (dx, dy) toward nearest enemy, or nil if none found.
-- Need to check for enemy on screen to avoid targeting offscreen enemies.
function Player:get_nearest_target_vector(maxRange)
    if not self.room then return nil end
    local nearest = nil
    local nearest_dist = math.huge
    local center_x = self.x + (self.width or 0) / 2
    local center_y = self.y + (self.height or 0) / 2

    for _, e in ipairs(self.room.entities) do
        if e ~= self and not e.dead then
            local target_x = e.x + (e.width or 0) / 2
            local target_y = e.y + (e.height or 0) / 2
            local dx = target_x - center_x
            local dy = target_y - center_y
            local d = math.sqrt(dx * dx + dy * dy)
            if (not maxRange or d <= maxRange) and d < nearest_dist then
                nearest_dist = d
                nearest = {dx = dx, dy = dy, target = e}
            end
        end
    end

    if not nearest then return nil end

    local len = math.sqrt(nearest.dx * nearest.dx + nearest.dy * nearest.dy)
    if len == 0 then return nil end

    return nearest.dx / len, nearest.dy / len, nearest.target
end
