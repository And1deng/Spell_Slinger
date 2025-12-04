StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		processAI = function() end,
		enter = function() end,
		exit = function() end
	}
    self.stateConstructors = states or {}
    self.stateInstances = {}  -- Cache for state instances
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.stateConstructors[stateName])
    
    self.current:exit()
    
    -- Get or create state instance
    if not self.stateInstances[stateName] then
        self.stateInstances[stateName] = self.stateConstructors[stateName]()
    end
    
    self.current = self.stateInstances[stateName]
    self.current:enter(enterParams)
end
function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end

function StateMachine:processAI(params, dt)
	self.current:processAI(params, dt)
end