Enemy = Class{__includes = Entity}

function Enemy:init(def)
    Entity.init(self, def)

    -- prefer base enemy states where available
    self.state_machine = StateMachine {
        ['idle']   = function() return BaseEnemyIdle(self) end,
        ['walk']   = function() return EntityWalkState(self) end,
        ['attack'] = function() return BaseEnemyAttack(self) end,
        ['death'] = function() return BaseEnemyDeath(self) end
    }

    self.state_machine:change('idle')

    -- store attack name (optional) and instantiate AI
    self.attack_name = def.attack or nil

    -- prefer an aggro AI profile if provided, else default roaming AI
    if def.ai_profile and def.ai_profile.type == 'aggro' then
        self.ai = BaseEnemyAggro(self, def.room or nil, def.ai_profile.range)
        local DebugLog = require 'src.DebugLog'
        DebugLog.log("[Enemy:init] Created aggro AI for enemy: attack=%s range=%s room=%s", tostring(self.attack_name), tostring(def.ai_profile.range), tostring(def.room))
    else
        self.ai = BaseEnemyAI(self, def.room or nil)
        local DebugLog = require 'src.DebugLog'
        DebugLog.log("[Enemy:init] Created roaming AI for enemy: attack=%s room=%s", tostring(self.attack_name), tostring(def.room))
    end
end

function Enemy:update(dt)
    if self.ai and self.ai.update then
        self.ai:update(dt)
    end

    if self.state_machine then
        self.state_machine:update(dt)
    end
end

-- Simple helper: return normalized vector toward the player if present
function Enemy:get_nearest_target_vector(maxRange)
    if not self.room or not self.room.player then return nil end

    local center_x = self.x + (self.width or 0) / 2
    local center_y = self.y + (self.height or 0) / 2

    local target_x = self.room.player.x + (self.room.player.width or 0) / 2
    local target_y = self.room.player.y + (self.room.player.height or 0) / 2

    local dx = target_x - center_x
    local dy = target_y - center_y
    local d = math.sqrt(dx * dx + dy * dy)

    if d == 0 then return nil end
    if maxRange and d > maxRange then return nil end

    return dx / d, dy / d, self.room.player
end
