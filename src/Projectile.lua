local Projectile = {}
Projectile.__index = Projectile

function Projectile.new(x, y, vx, vy, damage, lifetime)
    local self = setmetatable({}, Projectile)
    self.x = x
    self.y = y
    self.vx = vx
    self.vy = vy
    self.damage = damage or 10
    self.lifetime = lifetime or 5
    self.age = 0
    self.active = true
    return self
end

function Projectile:update(dt)
    self.age = self.age + dt
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    
    if self.age >= self.lifetime then
        self.active = false
    end
end

function Projectile:draw()
    if self.active then
        love.graphics.circle("fill", self.x, self.y, 5)
    end
end

function Projectile:isActive()
    return self.active
end

return Projectile