--[[BaseEnemyAttack
Attack state for enemies
Ranged/custom attacks use attack_def.onFire
Melee attacks use a temporary hitbox in front of the enemy
]]--
BaseEnemyAttack = Class{__includes = EntityAttackState}

function BaseEnemyAttack:init(entity)
    self.entity = entity
    self.attack = nil
    self.windup = 0
    self.windup_timer = 0
    self.fired = false
    self.hitbox = nil
end

function BaseEnemyAttack:enter(attack_def)

    if DEBUG_MODE then
        DebugLog.log("[BaseEnemyAttack:enter] enemy=%s attack=%s", tostring(self.entity), tostring(self.attack))
    end
    self.windup_timer = 0
    self.fired = false
    self.attack = attack_def
    self.windup = self.attack.windup
    self.hitbox = nil

    self.entity:changeAnimation('attack_' .. self.entity.direction)

    -- Only create a melee hitbox if this attack does not define its own onFire behavior
    if not self.attack or self.attack.onFire then
        return
    end

    local dir = self.entity.direction
    local reach = 12
    local x, y, w, h

    if dir == 'left' then
        x = self.entity.x - reach
        y = self.entity.y
        w = reach
        h = self.entity.height
    elseif dir == 'right' then
        x = self.entity.x + self.entity.width
        y = self.entity.y
        w = reach
        h = self.entity.height
    elseif dir == 'up' then
        x = self.entity.x
        y = self.entity.y - reach
        w = self.entity.width
        h = reach
    else
        x = self.entity.x
        y = self.entity.y + self.entity.height
        w = self.entity.width
        h = reach
    end

    self.hitbox = {
        x = x,
        y = y,
        width = w,
        height = h
    }
end

function BaseEnemyAttack:update(dt)
    if not self.attack then
        self.entity:changeState('idle')
        return
    end

    self.windup_timer = self.windup_timer + dt

    --Fire once after windup
    if self.windup_timer >= (self.attack.windup) and not self.fired then
        self.fired = true
        if DEBUG_MODE then
            DebugLog.log("[BaseEnemyAttack] windup done")
        end

        --Ranged attack behavior
        if self.attack.onFire then
            self.attack.onFire(self.entity)

            if DEBUG_MODE then
                DebugLog.log("[BaseEnemyAttack] onFire executed for attack %s", tostring(self.attack))
            end

        --Default melee behavior
        else
            local player = self.entity.room and self.entity.room.player

            if player and not player.dead and not player.invulnerable and self.hitbox then
                if not (
                    self.hitbox.x + self.hitbox.width < player.x or
                    self.hitbox.x > player.x + player.width or
                    self.hitbox.y + self.hitbox.height < player.y or
                    self.hitbox.y > player.y + player.height
                ) then
                    player:dealDamage(self.entity.damage)
                    if player.dead then
                        self.entity.room.frozen = true
                    end

                    
                end
            end
        end
    end

    if self.windup_timer >= self.attack.lifetime then
        self.entity:changeState('idle')
    end
end

function BaseEnemyAttack:render()
    if DEBUG_MODE and self.hitbox then
        love.graphics.setColor(1, 1, 0, 0.35)
        love.graphics.rectangle(
            "fill",
            self.hitbox.x,
            self.hitbox.y,
            self.hitbox.width,
            self.hitbox.height
        )

        love.graphics.setColor(1, 1, 0, 1)
        love.graphics.rectangle(
            "line",
            self.hitbox.x,
            self.hitbox.y,
            self.hitbox.width,
            self.hitbox.height
        )

        love.graphics.setColor(1, 1, 1, 1)
    end
end