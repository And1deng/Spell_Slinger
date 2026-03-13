--State Machine. Credit to CS50's intro to game development course.
StateMachine = Class{}

function StateMachine:init(states) 
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
    --Cache for state instances to prevent unnecessary re-instantiation
    self.stateConstructors = states or {}
    self.stateInstances = {}
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.stateConstructors[stateName])
    
    self.current:exit()
     
    -- Get or create state instance from cache
    if not self.stateInstances[stateName] then
        self.stateInstances[stateName] = self.stateConstructors[stateName]()
    end
    
    self.current = self.stateInstances[stateName]
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end