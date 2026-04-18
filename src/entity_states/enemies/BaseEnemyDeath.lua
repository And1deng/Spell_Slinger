--[[BaseEnemyDeath
Death state for the base enemy (slime)
No death animation at the moment
]]--
BaseEnemyDeath = Class{__includes = EntityDeathState}

function BaseEnemyDeath:init(enemy)
    EntityDeathState.init(self, enemy)
end

function BaseEnemyDeath:enter(params)
    EntityDeathState.enter(self, params)
end

function BaseEnemyDeath:update(dt)
end
