--[[Entity
Credit to Colton Ogden's CS50G work for the base structure and functions of this class
Added modifications and additions for our specific game needs such as healthbar display, invulnerability frames, 
    and more general functions for state and animation changes that can be used by both player and enemies.
]]--
Entity = Class{}

function Entity:init(def)
    self.direction = 'down'
    self.room = def.room

    self.animations = self:createAnimations(def.animations or {})
    self.flip = def.flip or false

    self.x = def.x or 0
    self.y = def.y or 0
    self.width = def.width or 16
    self.height = def.height or 16

    --Offsets for sprite differences if needed
    self.offset_x = def.offset_x or 0
    self.offset_y = def.offset_y or 0

    self.walk_speed = def.walk_speed or 30
    self.dx = 0
    self.dy = 0

    --For healthbar display
    self.max_health = def.max_health or 1
    self.health = def.health or self.max_health

    --Can be changed to work with entity specific invulerability frames
    self.invulnerable = false
    self.invulnerable_duration = def.invulnerable_duration or nil
    self.invulnerable_timer = 0

    self.ranged = def.ranged or false
    self.dead = false
    self.remove = false
end

function Entity:createAnimations(animations)
    local anims = {}

    for k, def in pairs(animations) do
        anims[k] = Animation {
            texture = def.texture or 'entities',
            frames = def.frames,
            interval = def.interval or 0.15,
            looping = def.looping,
            flip = def.flip
        }
    end

    return anims
end

--AABB collision detection
function Entity:collides(target)
    return not (self.x + self.width < target.x or
                self.x > target.x + target.width or
                self.y + self.height < target.y or
                self.y > target.y + target.height)
end

function Entity:dealDamage(dmg)
    if self.dead then return end

    self.health = self.health - dmg

    if self.health <= 0 then
        self.dead = true
        self:changeState('death')
        self:changeAnimation('death')
    end
end

function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerable_duration = duration
    self.invulnerable_timer = 0
end

function Entity:changeState(name, params)
    if DEBUG_MODE then
        DebugLog.log("[Entity:changeState] %s -> %s", tostring(self), tostring(name))
    end
    self.state_machine:change(name, params)
end
function Entity:changeAnimation(name)
    local newAnimation = self.animations[name]
    if not newAnimation then return end

    if self.currentAnimation ~= newAnimation then
        self.currentAnimation = newAnimation
        self.currentAnimation:refresh()
    end
end

function Entity:update(dt)
    if self.state_machine then
        self.state_machine:update(dt)
    end

    if self.dead then
        if self.currentAnimation then
            self.currentAnimation:update(dt)

            --Remove entity AFTER death animation finishes
            if self.currentAnimation.times_played > 0 then
                self.remove = true
            end
        end
        return
    end

    if self.invulnerable then
        self.invulnerable_timer = self.invulnerable_timer + dt

        if self.invulnerable_timer > self.invulnerable_duration then
            self.invulnerable = false
            self.invulnerable_timer = 0
        end
    end

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

end


function Entity:render()
    local anim = self.currentAnimation
    if not anim then
        return
    end

    local texture = gTextures[anim.texture]
    local quad = gFrames[anim.texture] and gFrames[anim.texture][anim:getCurrentFrame()]
    if not texture or not quad then
        return
    end

    local draw_x = math.floor(self.x - (self.offset_x or 0))
    local draw_y = math.floor(self.y - (self.offset_y or 0))

    --We only need the quadW here
    local quad_x, quad_y, quad_w, quad_h = quad:getViewport()

    local scale_x = 1
    if anim.flip then
        scale_x = -1
        draw_x = draw_x + quad_w
    end

    --Red rectangle for hitbox
    if DEBUG_MODE and not self.dead then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end

    --If invulnerable, render with 50% opacity to indicate state
    if self.invulnerable then
        love.graphics.setColor(1, 1, 1, 0.5)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    love.graphics.draw(texture, quad, draw_x, draw_y, 0, scale_x, 1)
end


return Entity
