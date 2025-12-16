Projectile = Class{}

function Projectile:init(params)
    -- support either a simple texture (`params.texture`) or an animations table (`params.animations`)
    self.x = params.x
    self.y = params.y
    self.width = params.width
    self.height = params.height
    self.texture = params.texture
    self.animations = params.animations and self:create_animations(params.animations) or nil

    self.speed = params.speed or 200
    self.direction = params.direction or 'right'

    -- compute velocity based on direction
    if self.direction == 'right' then
        self.vx, self.vy = self.speed, 0
    elseif self.direction == 'left' then
        self.vx, self.vy = -self.speed, 0
    elseif self.direction == 'up' then
        self.vx, self.vy = 0, -self.speed
    elseif self.direction == 'down' then
        self.vx, self.vy = 0, self.speed
    end

    self.damage = params.damage
    self.lifetime = params.lifetime
    self.age = 0
    self.active = true
    -- choose initial animation if animations were provided
    if self.animations then
        -- prefer explicit animation name, else pick first available
        local animName = params.animation or next(self.animations)
        self.current_animation = self.animations[animName]
    else
        self.current_animation = nil
    end

    self.hurtbox = Hitbox(params.x, params.y, params.width, params.height)
    -- compute sprite offsets (prefer snake_case params, accept camelCase for compatibility)
    self.offset_x = params.offset_x or params.offsetX or 0
    self.offset_y = params.offset_y or params.offsetY or 0
    if params.offset_x == nil and params.offsetX == nil and self.current_animation then
        local quad = gFrames[self.current_animation.texture][self.current_animation:getCurrentFrame()]
        if quad and quad.getViewport then
            local _, _, fw, fh = quad:getViewport()
            self.offset_x = math.floor(fw / 2)
            self.offset_y = math.floor(fh / 2)
        end
    end

    -- Allow explicit velocity or directional vector (dx/dy) for diagonal movement
    if params.vx and params.vy then
        self.vx, self.vy = params.vx, params.vy
    elseif params.dx and params.dy then
        local len = math.sqrt(params.dx * params.dx + params.dy * params.dy)
        if len > 0 then
            self.vx = (params.dx / len) * self.speed
            self.vy = (params.dy / len) * self.speed
        else
            self.vx, self.vy = self.speed, 0
        end
    else
        -- keep previously computed cardinal velocity from params.direction
        -- (already set earlier based on `self.direction`)
    end
end

function Projectile:update(dt)
    if not self.active then return end

    self.age = self.age + dt

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if self.current_animation then
        self.current_animation:update(dt)
    end

    if self.age >= self.lifetime then
        self.active = false
    end
end

function Projectile:create_animations(animations)
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

function Projectile:render()
    if not self.active then return end

    if self.current_animation then
        local anim = self.current_animation
        local texture = gTextures[anim.texture]
        local quad = gFrames[anim.texture][anim:getCurrentFrame()]
        love.graphics.draw(texture, quad, math.floor(self.x - self.offset_x), math.floor(self.y - self.offset_y), 0, self.width / texture:getDimensions(), self.height / texture:getDimensions())
    elseif self.texture then
        local texture = gTextures[self.texture]
        love.graphics.draw(texture, math.floor(self.x - self.offset_x), math.floor(self.y - self.offset_y), 0, self.width / texture:getDimensions(), self.height / texture:getDimensions())
    end
end

function Projectile:is_active()
    return self.active
end

function Projectile:change_animation(name)
    if self.animations and self.animations[name] then
        self.current_animation = self.animations[name]
    end
end
