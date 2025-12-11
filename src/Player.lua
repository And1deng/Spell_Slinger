Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    -- Casting system
    self.castBuffer = {}
    self.castTimer = 0
    self.castTimeout = 2.0
    self.maxCastInputs = 3
end

function Player:update(dt)
    -- Normal entity + state update
    Entity.update(self, dt)

    -- Casting update (runs independently of movement states)
    self:updateCast(dt)
end

function Player:updateCast(dt)
    -- Advance timer and clear cast if stale
    self.castTimer = self.castTimer + dt
    if self.castTimer > self.castTimeout then
        self.castBuffer = {}
        self.castTimer = 0
    end

    -- Handle new directional input
    local pressed = nil
    if love.keyboard.wasPressed("up") then pressed = "up"
    elseif love.keyboard.wasPressed("down") then pressed = "down"
    elseif love.keyboard.wasPressed("left") then pressed = "left"
    elseif love.keyboard.wasPressed("right") then pressed = "right"
    end

    if pressed then
        table.insert(self.castBuffer, pressed)
        self.castTimer = 0   -- reset since an input was added
    end

    -- Check for max inputs → try cast spell
    if #self.castBuffer == self.maxCastInputs then
        local spell = self:matchSpell()
        
        if spell then
            -- Cast!
            if spell.onFire then
                spell.onFire(self)
            end
            -- Reset buffer after cast
            self.castBuffer = {}
            self.castTimer = 0
        else
            -- Slide buffer window forward (like fighting game input buffer)
            table.remove(self.castBuffer, 1)
        end
    end
end

-- Compare buffer with ATTACK_DEFS
function Player:matchSpell()
    for spellName, spell in pairs(ATTACK_DEFS) do
        if #spell.input == self.maxCastInputs then
            if  self.castBuffer[1] == spell.input[1] and
                self.castBuffer[2] == spell.input[2] and
                self.castBuffer[3] == spell.input[3] then
                return spell
            end
        end
    end
    return nil
end

-- Render player normally + cast overlay UI
function Player:render()
    Entity.render(self)
    self:renderCast()
end

function Player:renderCast()
    if #self.castBuffer == 0 then
        return
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['DefaultFont'])

    local text = table.concat(self.castBuffer, " ")

    -- Draw at the bottom of the screen
    love.graphics.printf(
        "Cast: " .. text,
        0,
        VIRTUAL_HEIGHT - 32,
        VIRTUAL_WIDTH,
        "center"
    )
end
