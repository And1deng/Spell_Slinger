--[[BaseEnemyIdle
Base idle state for enemies
Enemies will wait and AI will cause them to change direction or start walking after a random duration
]]--
BaseEnemyIdle = Class{__includes = BaseState}

function BaseEnemyIdle:init(entity)
    self.entity = entity

    self.wait_duration = 0
    self.wait_timer = 0

    self.entity:changeAnimation('idle_' .. self.entity.direction)
end

function BaseEnemyIdle:update(dt)
    if self.wait_duration == 0 then
        self.wait_duration = math.random(3)
    else
        self.wait_timer = self.wait_timer + dt

        if self.wait_timer > self.wait_duration then
            self.entity:changeState('walk')
        end
    end
end