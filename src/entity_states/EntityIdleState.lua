--[[EntityIdleState
Base idle state for all entities
Contains AI processing for idle behavior, for livlier enemies and NPCs
]]--

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity

    self.entity:changeAnimation('idle_' .. self.entity.direction)

    -- used for AI waiting
    self.wait_duration = 0
    self.wait_timer = 0
end

function EntityIdleState:process_ai(params, dt)
    if self.wait_duration == 0 then
        self.wait_duration = math.random(5)
    else
        self.wait_timer = self.wait_timer + dt

        if self.wait_timer > self.wait_duration then
            self.entity:changeState('walk')
        end
    end
end