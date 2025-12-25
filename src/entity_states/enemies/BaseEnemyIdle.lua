BaseEnemyIdle = Class{__includes = BaseState}

function BaseEnemyIdle:init(entity)
    self.entity = entity

    self.wait_duration = 0
    self.wait_timer = 0

    -- set an idle animation matching current direction
    self.entity:change_animation('idle-' .. self.entity.direction)
end

function BaseEnemyIdle:update(dt)
    if self.wait_duration == 0 then
        self.wait_duration = math.random(3)
    else
        self.wait_timer = self.wait_timer + dt

        if self.wait_timer > self.wait_duration then
            self.entity:change_state('walk')
        end
    end
end