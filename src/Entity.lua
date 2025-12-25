Entity = Class{}

local DEBUG_ENTITY_STATES = true

function Entity:init(def)
    -- top-down direction
    self.direction = 'down'
    self.room = def.room or nil

    -- animations
    self.animations = self:create_animations(def.animations or {})

    -- position & size
    self.x = def.x or 0
    self.y = def.y or 0
    self.width = def.width or 16
    self.height = def.height or 16

    -- drawing offsets (prefer snake_case, accept camelCase for compatibility)
    self.offset_x = def.offset_x or def.offsetX or 0
    self.offset_y = def.offset_y or def.offsetY or 0

    -- movement
    self.walk_speed = def.walk_speed or 30
    self.dx = 0
    self.dy = 0

    -- health
    self.max_health = def.max_health or 1
    self.health = def.health or self.max_health

    -- invulnerability
    self.invulnerable = false
    self.invulnerable_duration = 0
    self.invulnerable_timer = 0
    self.flash_timer = 0

    self.dead = false
    self.remove = false
end

function Entity:create_animations(animations)
    local anims = {}

    for k, def in pairs(animations) do
        anims[k] = Animation {
            texture = def.texture or 'entities',
            frames = def.frames,
            interval = def.interval or 0.15
        }
    end

    return anims
end

function Entity:collides(target)
    return not (self.x + self.width < target.x or
                self.x > target.x + target.width or
                self.y + self.height < target.y or
                self.y > target.y + target.height)
end

function Entity:deal_damage(dmg)
    if self.dead then return end

    self.health = self.health - dmg

    if self.health <= 0 then
        self.dead = true
        self:change_state('death')
        self:change_animation('death')
    end
end

function Entity:go_invulnerable(duration)
    self.invulnerable = true
    self.invulnerable_duration = duration
end

function Entity:change_state(name)
    if DEBUG_ENTITY_STATES then
        local DebugLog = require 'src.DebugLog'
        DebugLog.log("[Entity:change_state] %s -> %s", tostring(self), tostring(name))
    end
    self.state_machine:change(name)
end

function Entity:change_animation(name)
    self.current_animation = self.animations[name]
    self.current_animation:refresh()
end

function Entity:update(dt)

    -- =========================
    -- DEATH HANDLING (TOP PRIORITY)
    -- =========================
    if self.dead then
        if self.current_animation then
            self.current_animation:update(dt)

            -- remove entity AFTER death animation finishes
            if self.current_animation.timesPlayed > 0 then
                self.remove = true
            end
        end
        return
    end

    -- =========================
    -- INVULNERABILITY
    -- =========================
    if self.invulnerable then
        self.flash_timer = self.flash_timer + dt
        self.invulnerable_timer = self.invulnerable_timer + dt

        if self.invulnerable_timer > self.invulnerable_duration then
            self.invulnerable = false
            self.invulnerable_timer = 0
            self.invulnerable_duration = 0
            self.flash_timer = 0
        end
    end

    -- =========================
    -- ANIMATION
    -- =========================
    if self.current_animation then
        self.current_animation:update(dt)
    end

    -- =========================
    -- STATE MACHINE
    -- =========================
    if self.state_machine then
        self.state_machine:update(dt)
    end
end


function Entity:render()
    local anim = self.current_animation

    local texture = gTextures[anim.texture]
    if not texture then return end
    local quad = gFrames[anim.texture] and gFrames[anim.texture][anim:getCurrentFrame()]
    if not quad then return end

    local scaleX = anim.flip and -1 or 1

    love.graphics.draw(
        texture,
        quad,
        math.floor(self.x - (self.offset_x or 0)),
        math.floor(self.y - (self.offset_y or 0)),
        0,        -- rotation
        scaleX, 1 -- scaleX flips if -1
    )
end


return Entity
