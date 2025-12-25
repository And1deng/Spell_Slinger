-- EntityDeathState.lua
EntityDeathState = Class{__includes = BaseState}

function EntityDeathState:init(entity)
    self.entity = entity
end

function EntityDeathState:enter(params)
    -- Immediately mark entity as dead when it enters the death state
    self.entity.dead = true

    -- Call the entity's onDeath method, if it exists
    if self.entity.onDeath then
        self.entity:onDeath()
    end

    -- Ensure the death animation starts immediately
    if self.entity.change_animation then
        self.entity:change_animation('death')
    end
end

function EntityDeathState:update(dt)
    -- No fade logic needed, just mark the entity as dead immediately when entering death state
    -- You can add any additional logic for death behavior here if needed
end

function EntityDeathState:render()
    -- Simply render the entity in its death animation (no fading)
    if self.entity.render then
        self.entity:render()
    end
end
