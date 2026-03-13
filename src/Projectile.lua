Projectile = Class{}

function Projectile:init(params)
    --Passed parameters from attack_definitions.lua
    self.texture = params.texture
    self.x = params.x
    self.y = params.y
    self.width = params.width
    self.height = params.height
    self.dx = params.dx
    self.dy = params.dy
    self.speed = params.speed or 200
    self.damage = params.damage or 1
    self.lifetime = params.lifetime or 1

    --Utils for animations and projectile behavior
    self.animations = params.animations and self:create_animations(params.animations) or nil
    self.direction = params.direction or 'right'
    self.age = 0
    self.active = true

    --Runs with or without animations (so I can use a png for development)
    if self.animations then
        local animName = params.animation or next(self.animations)
        self.current_animation = self.animations[animName]
    else
        self.current_animation = nil
    end

    self.hurtbox = Hitbox(params.x, params.y, params.width, params.height)

    --Offset if projectile texture is misaligned
    self.offset_x = params.offset_x or params.offsetX or 0
    self.offset_y = params.offset_y or params.offsetY or 0

    --Projectile velocity calculation, dx and dy are passed as direction unit vector components
    if params.dx and params.dy then
            self.vx = params.dx * self.speed
            self.vy = params.dy * self.speed
    end
end

function Projectile:update(dt)
    if not self.active then 
        return 
    end

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

--Both animation functions copied from Entity.lua for future animation support
function Projectile:create_animations(animations)
    local anims = {}

    for k, def in pairs(animations) do
        anims[k] = Animation {
            texture = def.texture or 'entities',
            frames = def.frames,
            interval = def.interval or 0.15,
            looping = def.looping
        }
    end

    return anims
end


function Projectile:change_animation(name)
    local new_animation = self.animations[name]
    if not new_animation then return end

    if self.current_animation ~= new_animation then
        self.current_animation = new_animation
        self.current_animation:refresh()
    end
end

function Projectile:render()
    if not self.active then return end

    if self.current_animation then
        local anim = self.current_animation
        local texture = gTextures[anim.texture]
        local quad = gFrames[anim.texture][anim:getCurrentFrame()]
        local texture_w, texture_h = texture:getDimensions()
        love.graphics.draw(texture, quad, math.floor(self.x - self.offset_x), math.floor(self.y - self.offset_y),
            0, self.width / texture_w, self.height / texture_h)
    elseif self.texture then
        local texture = gTextures[self.texture]
        local texture_w, texture_h = texture:getDimensions()
        love.graphics.draw(texture, math.floor(self.x - self.offset_x), math.floor(self.y - self.offset_y), 0, self.width / texture_w, self.height / texture_h)
    end
end
