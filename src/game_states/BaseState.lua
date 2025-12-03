BaseState = Class{}

-- constructor (optional, can be used for default values)
function BaseState:init()
end

-- called when the state is entered
function BaseState:enter(params)
end

-- called when the state is exited
function BaseState:exit()
end

-- called every frame
function BaseState:update(dt)
end

-- called every frame to render
function BaseState:render()
end

-- optional separate AI processing
function BaseState:processAI(params, dt)
end
