Entity = Class()

function Entity:init(def)
    -- top-down direction
    self.direction = 'down'

    -- animations
    self.animations = self:createAnimations(def.animations or {})

    -- position & size
    self.x = def.x or 0
    self.y = def.y or 0
    self.width = def.width or 16
    self.height = def.height or 16

    -- drawing offsets
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    -- movement
    self.walkSpeed = def.walkSpeed or 30

    -- health
    self.health = def.health or 1

    -- invulnerability
    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0
    self.flashTimer = 0

    self.dead = false
end

function Entity:createAnimations(animations)
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

function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

function Entity:changeState(name)
    print("Changing state from " .. tostring(self.stateMachine.current.__classname) .. " to " .. name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
    -- invulnerability timing
    if self.invulnerable then
        self.flashTimer = self.flashTimer + dt
        self.invulnerableTimer = self.invulnerableTimer + dt

        if self.invulnerableTimer > self.invulnerableDuration then
            self.invulnerable = false
            self.invulnerableTimer = 0
            self.invulnerableDuration = 0
            self.flashTimer = 0
        end
    end

    -- update animation + state
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    if self.stateMachine then
        self.stateMachine:update(dt)
    end
end

function Entity:render(adjX, adjY)
    love.graphics.setColor(1, 0, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end

return Entity
