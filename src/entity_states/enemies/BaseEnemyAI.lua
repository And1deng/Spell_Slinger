BaseEnemyAI = Class{}

-- Enable AI debug prints in console (set to false to quiet)
local DEBUG_AI = true
local DebugLog = require 'src.DebugLog'

local DIRECTIONS = {'left', 'right', 'up', 'down'}

function BaseEnemyAI:init(enemy, room)
    self.enemy = enemy
    self.room = room

    self.move_duration = 0
    self.movement_timer = 0
end

function BaseEnemyAI:update(dt)
    local enemy = self.enemy

    self.movement_timer = self.movement_timer + dt

    -- debug log: show AI timers and position
    if DEBUG_AI then
        DebugLog.log("[BaseEnemyAI] enemy at (%.1f,%.1f) move_duration=%.2f movement_timer=%.2f", enemy.x or 0, enemy.y or 0, self.move_duration or 0, self.movement_timer or 0)
    end

    -- if we haven't picked a duration or the entity bumped, pick a new direction
    if self.move_duration == 0 or (enemy.state_machine and enemy.state_machine.current and enemy.state_machine.current.bumped) then
        if DEBUG_AI then DebugLog.log("[BaseEnemyAI] picking new direction (initial or bumped)") end
        self:pick_new_direction()
    elseif self.movement_timer > self.move_duration then
        self.movement_timer = 0

        if math.random(3) == 1 then
            if DEBUG_AI then DebugLog.log("[BaseEnemyAI] switching to idle") end
            enemy:change_state('idle')
        else
            if DEBUG_AI then DebugLog.log("[BaseEnemyAI] picking new direction (timer expired)") end
            self:pick_new_direction()
        end
    end
end

function BaseEnemyAI:pick_new_direction()
    self.move_duration = math.random(5)
    self.enemy.direction = DIRECTIONS[math.random(#DIRECTIONS)]
    if DEBUG_AI then DebugLog.log("[BaseEnemyAI] pick_new_direction -> %s", self.enemy.direction) end
    self.enemy:change_animation('walk-' .. self.enemy.direction)
    self.enemy:change_state('walk')
end
