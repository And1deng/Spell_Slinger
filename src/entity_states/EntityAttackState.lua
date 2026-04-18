--[[EntityAttackState
Base attack state for all entities
Handles attack animation timing and logic for unique windup times and fire logic
]]--
EntityAttackState = Class{__includes = BaseState}

function EntityAttackState:init(entity, attack)
    self.entity = entity
    self.attack = attack 
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

    --Reset to idle as a default
    if self.timer >= self.attack.total_duration then
        self.entity.state_machine:change('idle')
    end
end