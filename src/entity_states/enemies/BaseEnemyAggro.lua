BaseEnemyAggro = Class{}

local DebugLog = require 'src.DebugLog'
local DEBUG_AI = true

function BaseEnemyAggro:init(enemy, room, range)
    self.enemy = enemy
    self.room = room
    self.range = range or 120
    self.base_ai = BaseEnemyAI(enemy, room)
end

function BaseEnemyAggro:update(dt)
    if self.room and self.room.player and not self.room.player.dead then
        local px = self.room.player.x + (self.room.player.width or 0) / 2
        local py = self.room.player.y + (self.room.player.height or 0) / 2
        local ex = self.enemy.x + (self.enemy.width or 0) / 2
        local ey = self.enemy.y + (self.enemy.height or 0) / 2

        local dx = px - ex
        local dy = py - ey
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist <= self.range then
            -- If the enemy has a ranged attack, use it
            if self.enemy.attack_name and ATTACK_DEFS[self.enemy.attack_name] then
                if DEBUG_AI then DebugLog.log("[BaseEnemyAggro] in range; using ranged attack: %s", tostring(self.enemy.attack_name)) end
                self.enemy.state_machine:change('attack', ATTACK_DEFS[self.enemy.attack_name])
                return
            else
                -- No ranged attack → chase the player (melee contact damage)
                local dir
                if math.abs(dx) > math.abs(dy) then
                    dir = dx > 0 and 'right' or 'left'
                else
                    dir = dy > 0 and 'down' or 'up'
                end

                if DEBUG_AI then DebugLog.log("[BaseEnemyAggro] chasing player dist=%.1f dir=%s", dist, dir) end

                self.enemy.direction = dir
                self.enemy:change_animation('walk-' .. dir)
                self.enemy:change_state('walk')
                return
            end
        end
    end

    -- fallback to wandering behavior
    self.base_ai:update(dt)
end