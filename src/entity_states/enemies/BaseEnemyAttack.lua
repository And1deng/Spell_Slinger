BaseEnemyAttack = Class{__includes = BaseState}

function BaseEnemyAttack:init(entity)
    self.entity = entity
    self.attack = nil
    self.timer = 0
    self.fired = false
end

function BaseEnemyAttack:enter(attack_def)
    self.timer = 0
    self.fired = false
    self.attack = attack_def

    if self.attack and self.attack.animation then
        self.entity:change_animation(self.attack.animation)
    end
end

function BaseEnemyAttack:update(dt)
    if not self.attack then
        self.entity:change_state('idle')
        return
    end

    self.timer = self.timer + dt

    if self.timer >= (self.attack.windup or 0) and not self.fired then
        self.fired = true
        if self.attack.on_fire then
            self.attack.on_fire(self.entity)
        end
    end

    if self.timer >= (self.attack.total_duration or 0) then
        self.entity:change_state('idle')
    end
end