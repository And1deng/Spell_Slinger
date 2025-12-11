EntityAttackState = Class{__includes = BaseState}

function EntityAttackState:init(entity, attack)
    self.entity = entity
    self.attack = attack -- in the entity definitions
end

function EntityAttackState:enter()
    self.timer = 0
    self.entity:changeAnimation(self.attack.animation)
end

function EntityAttackState:update(dt)
    self.timer = self.timer + dt

    if self.timer >= self.attack.windup and not self.fired then
        self.fired = true
        if self.attack.onFire then
            self.attack.onFire(self.entity)
        end
    end

    if self.timer >= self.attack.totalDuration then
        self.entity.stateMachine:change('idle')
    end
end