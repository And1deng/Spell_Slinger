--[[Projectile
Used for spells and other ranged attacks
Takes parameters from attack_definitions.lua and provides update and render functions for projectiles in the game world
]]--
Projectile = Class{}

function Projectile:init(params)
    --Passed parameters from attack_definitions.lua
    self.owner = params.owner or nil
    self.texture = params.texture
    self.x = params.x
    self.y = params.y
    self.width = params.width
    self.height = params.height
    self.vector_x = params.vector_x
    self.vector_y = params.vector_y
    self.speed = params.speed
    self.damage = params.damage
    self.lifetime = params.lifetime

    --Utils for animations and projectile behavior
    self.animations = params.animations and self:createAnimations(params.animations) or nil
    self.direction = params.direction or 'right'
    self.age = 0
    self.active = true
    self.sprite_rotation = math.atan2(self.vector_y, self.vector_x)

    --Runs with or without animations (so I can use a png for development)
    if self.animations then
        local animName = params.animation or next(self.animations)
        self.currentAnimation = self.animations[animName]
    else
        self.currentAnimation = nil
    end

    self.hurtbox = Hitbox(params.x, params.y, params.width, params.height)

    --Offset if projectile texture is misaligned
    self.offset_x = params.offset_x or params.offset_x or 0
    self.offset_y = params.offset_y or params.offset_y or 0

    if params.vector_x and params.vector_y then
            self.dx = params.vector_x * self.speed
            self.dy = params.vector_y * self.speed
    end
end

function Projectile:update(dt)
    if not self.active then 
        return 
    end

    self.age = self.age + dt

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    if self.age >= self.lifetime then
        self.active = false
    end
end

--Both animation functions copied from Entity.lua for future animation support
function Projectile:createAnimations(animations)
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


function Projectile:changeAnimation(name)
    local new_animation = self.animations[name]
    if not new_animation then return end

    if self.currentAnimation ~= new_animation then
        self.currentAnimation = new_animation
        self.currentAnimation:refresh()
    end
end

function Projectile:render()
    if not self.active then return end

    if self.currentAnimation then
        local anim = self.currentAnimation
        local texture = gTextures[anim.texture]
        local quad = gFrames[anim.texture][anim:getCurrentFrame()]
        local texture_w, texture_h = texture:getDimensions()
        love.graphics.draw(texture, quad, math.floor(self.x - self.offset_x), math.floor(self.y - self.offset_y),
            self.sprite_rotation, self.width / texture_w, self.height / texture_h)
    elseif self.texture then
        local texture = gTextures[self.texture]
        local texture_w, texture_h = texture:getDimensions()
        love.graphics.draw(texture, math.floor(self.x - self.offset_x), math.floor(self.y - self.offset_y), self.sprite_rotation, self.width / texture_w, self.height / texture_h)
    end
end
