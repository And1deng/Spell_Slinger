EntityAttackState = Class{__includes = BaseState}

function EntityAttackState:init(entity, attack)
    self.entity = entity
    self.attack = attack -- in the entity definitions
end

function EntityAttackState:enter()
    self.timer = 0
    self.entity:change_animation(self.attack.animation)
end

function EntityAttackState:update(dt)
    self.timer = self.timer + dt

    if self.timer >= self.attack.windup and not self.fired then
        self.fired = true
        if self.attack.on_fire then
            self.attack.on_fire(self.entity)
        end
    end

    if self.timer >= self.attack.total_duration then
        self.entity.state_machine:change('idle')
    end
end