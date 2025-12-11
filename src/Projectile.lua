Projectile = Class{}

function Projectile:init(params)
    self.texture = params.texture
    self.x = params.x
    self.y = params.y

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

    self.damage = params.damage or 10
    self.lifetime = params.lifetime or 3
    self.age = 0
    self.active = true
end

function Projectile:update(dt)
    if not self.active then return end

    self.age = self.age + dt

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if self.age >= self.lifetime then
        self.active = false
    end
end

function Projectile:render()
    if self.active then
        love.graphics.draw(gTextures[self.texture], self.x, self.y)
    end
end

function Projectile:isActive()
    return self.active
end
