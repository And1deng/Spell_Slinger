--[[EntityDeathState
Base death state for all entities
Ensure entity is marked dead, if an onDeath method exists call it for any animation or other logic
]]--
EntityDeathState = Class{__includes = BaseState}

function EntityDeathState:init(entity)
    self.entity = entity
end

function EntityDeathState:enter(params)
    self.entity.dead = true

    if self.entity.onDeath then
        self.entity:onDeath()
    end
    if self.entity.changeAnimation then
        self.entity:changeAnimation('death')
    end
end

function EntityDeathState:render()
    if self.entity.render then
        self.entity:render()
    end
end
