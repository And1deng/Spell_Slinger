Entity = Class{}

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

function Entity:damage(dmg)
    self.health = self.health - dmg
end

function Entity:go_invulnerable(duration)
    self.invulnerable = true
    self.invulnerable_duration = duration
end

function Entity:change_state(name)
    self.state_machine:change(name)
end

function Entity:change_animation(name)
    self.current_animation = self.animations[name]
end

function Entity:update(dt)
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

    -- update animation + state
    if self.current_animation then
        self.current_animation:update(dt)
    end

    if self.state_machine then
        self.state_machine:update(dt)
    end
end

function Entity:process_ai(params, dt)
    self.state_machine:process_ai(params, dt)
end

function Entity:render()
    local anim = self.current_animation
    local texture = gTextures[anim.texture]
    local quad = gFrames[anim.texture][anim:getCurrentFrame()]

    love.graphics.draw(texture, quad, math.floor(self.x - (self.offset_x or 0)), math.floor(self.y - (self.offset_y or 0)))
end


return Entity
