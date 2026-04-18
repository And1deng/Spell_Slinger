--[[Enemy
Base enemy class
Requires 4 states for now: idle, walk, attack, death
Starts in idle but uses a simple AI to determine what it will do (currently just idle, walk, or attack if player is in range)
Includes a helper function to track player and return normalized vector towards the player
]]--
Enemy = Class{__includes = Entity}


function Enemy:init(def)
    Entity.init(self, def)
    self.damage = def.damage
    self.attack_name = def.attack_name
    self.chase_range = def.chase_range
    self.attack_range = def.attack_range
    self.ranged = def.ranged or false

    if DEBUG_MODE then
    DebugLog.log("[Enemy:init] attack_name=%s ranged=%s chase_range=%s attack_range=%s",
        tostring(self.attack_name),
        tostring(self.ranged),
        tostring(self.chase_range),
        tostring(self.attack_range))
end

    self.state_machine = StateMachine {
        ['idle']   = function() return BaseEnemyIdle(self) end,
        ['walk']   = function() return EntityWalkState(self) end,
        ['attack'] = function() return BaseEnemyAttack(self) end,
        ['death'] = function() return BaseEnemyDeath(self) end
    }

    self.state_machine:change('idle')

    --Initialize AI based on profile in entity_definitions
    if def.ai_profile == 'aggro' then
        self.ai = BaseEnemyAggroAI(self, def.room, def.chase_range, def.attack_range, def.ranged)
    else
        --For passive enemies, just use random roaming AI
        self.ai = BaseEnemyAI(self, def.room)
    end
end

function Enemy:update(dt)
    if self.dead then
        Entity.update(self, dt)
        return
    end

    if self.ai and self.ai.update then
        self.ai:update(dt)
    end

    Entity.update(self, dt)
end

--Track enemy to player and return normalized vector pointing to player, or nil if no player or out of range
function Enemy:enemyGetNearestTargetVector()
    if not self.room or not self.room.player then return nil end

    local center_x = self.x + (self.width or 0) / 2
    local center_y = self.y + (self.height or 0) / 2

    local target_x = self.room.player.x + (self.room.player.width or 0) / 2
    local target_y = self.room.player.y + (self.room.player.height or 0) / 2

    local vector_x = target_x - center_x
    local vector_y = target_y - center_y
    local distance_to_player = math.sqrt(vector_x * vector_x + vector_y * vector_y)

    if distance_to_player == 0 then
        return 0, 0, self.room.player, 0
    end

    return vector_x / distance_to_player, vector_y / distance_to_player, self.room.player, distance_to_player
end