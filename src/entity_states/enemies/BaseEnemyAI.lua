--[[BaseEnemyAI
Base enemy AI for roaming around the room randomly when not aggroed
local direction enum for random movement and animation
Move for a random duration in a random direction, then either switch to idle or pick a new direction
]]--
BaseEnemyAI = Class{}

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

    if DEBUG_MODE then
        DebugLog.log("[BaseEnemyAI] enemy at (%.1f,%.1f)", enemy.x or 0, enemy.y or 0)
    end

    if self.move_duration == 0 or (enemy.state_machine and enemy.state_machine.current and enemy.state_machine.current.bumped) then
        if DEBUG_MODE then 
            DebugLog.log("[BaseEnemyAI] picking new direction (initial or bumped)") 
        end
        self:pickNewDirection()
    elseif self.movement_timer > self.move_duration then
        self.movement_timer = 0

        if math.random(3) == 1 then
            if DEBUG_MODE then 
                DebugLog.log("[BaseEnemyAI] switching to idle") 
            end
            enemy:changeState('idle')
        else
            if DEBUG_MODE then 
                DebugLog.log("[BaseEnemyAI] picking new direction (timer expired)") 
            end
            self:pickNewDirection()
        end
    end
end

function BaseEnemyAI:pickNewDirection()
    self.move_duration = math.random(5)
    self.enemy.direction = DIRECTIONS[math.random(#DIRECTIONS)]

    if DEBUG_MODE then 
        DebugLog.log("[BaseEnemyAI] pickNewDirection -> %s", self.enemy.direction) 
    end

    self.enemy:changeAnimation('walk_' .. self.enemy.direction)
    self.enemy:changeState('walk')
end
