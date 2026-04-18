--[[BaseEnemyAggroAI
Base enemy aggro behavior:
    1)Check for ranged attack
    2)Check for melee attack
    3)Chase player if in chase range
    4)Return to base enemy behavior (e.g. patrolling)
]]--
BaseEnemyAggroAI = Class{}

--Keep BaseEnemyAI to use for patrolling behavior when player not in range
function BaseEnemyAggroAI:init(enemy, room, chase_range, attack_range, is_ranged)
    self.enemy = enemy
    self.room = room
    self.chase_range = chase_range
    self.attack_range = attack_range
    self.is_ranged = is_ranged
    self.base_ai = BaseEnemyAI(enemy, room)
end

function BaseEnemyAggroAI:update(dt)
    local direction_x, direction_y, player, dist = self.enemy:enemyGetNearestTargetVector()

    if DEBUG_MODE then
        DebugLog.log("[AI] dist=%.2f attackRange=%s", dist, tostring(self.attack_range))
    end

    if player and not player.dead then
        --Attacking
        if dist <= self.attack_range then
            local direction
            if math.abs(direction_x) > math.abs(direction_y) then
                direction = direction_x > 0 and 'right' or 'left'
            else
                direction = direction_y > 0 and 'down' or 'up'
            end

            self.enemy.direction = direction

            --Ranged attacks
            if self.enemy.ranged and self.enemy.attack_name and ENEMY_ATTACK_DEFS[self.enemy.attack_name] then
                if self.enemy.state_machine.current_name ~= 'attack' then
                    if DEBUG_MODE then
                        DebugLog.log("[BaseEnemyAggro] target in attack range; using ranged attack %s", tostring(self.enemy.attack_name))
                    end
                    self.enemy:changeState('attack', ENEMY_ATTACK_DEFS[self.enemy.attack_name])
                end
                return
            end

            -- Melee attacks
            if self.enemy.attack_name and ENEMY_ATTACK_DEFS[self.enemy.attack_name] then
                if self.enemy.state_machine.current_name ~= 'attack' then
                    if DEBUG_MODE then
                        DebugLog.log("[BaseEnemyAggro] target in attack range; using melee attack %s", tostring(self.enemy.attack_name))
                    end
                    self.enemy:changeState('attack', ENEMY_ATTACK_DEFS[self.enemy.attack_name])
                end
                return
            end
            
        --Chasing
        elseif dist <= self.chase_range then
            local direction
            if math.abs(direction_x) > math.abs(direction_y) then
                direction = direction_x > 0 and 'right' or 'left'
            else
                direction = direction_y > 0 and 'down' or 'up'
            end

            if DEBUG_MODE then
                DebugLog.log("[BaseEnemyAggro] target in chase range; chasing dir=%s", direction)
            end

            self.enemy.direction = direction
            self.enemy:changeAnimation('walk_' .. direction)
            self.enemy:changeState('walk')
            return
        end
    end

    self.base_ai:update(dt)
end
