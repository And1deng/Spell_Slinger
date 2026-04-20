--[[StateMachine
Credit to Colton Ogden's CS50G work for the base structure and functions of this class

]]--
StateMachine = Class{}

function StateMachine:init(states) 
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}

    --Cache for state instances to prevent unnecessary re-instantiation
    self.state_constructors = states or {}
    self.state_instances = {}
    self.current = self.empty
end

function StateMachine:change(state_name, enter_params)
    assert(self.state_constructors[state_name])

    self.current:exit()

    if not self.state_instances[state_name] then
        self.state_instances[state_name] = self.state_constructors[state_name]()
    end

    --Added for BaseEnemyAggroAI to prevent recalling attack state without completing an attack
    self.current = self.state_instances[state_name]
    self.current_state = state_name
    self.current:enter(enter_params)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

--Added for hitbox debugging in BaseEnemyAttack
function StateMachine:render()
    self.current:render()
end