--[[Spell Slinger
A practice project for learning and implementing LUA and the LOVE2D framework.
2D, top down game where the player controls a wizard, fighting enemies with spells
Unique spell casting system where the player uses arrow keys to input spell patterns, auto targeting enemies.
]]--

--Dependencies contains the required libraries and files for the game
require 'src/Dependencies'

function love.load()
    love.window.setTitle('SpellSlinger')
    -- nearest, nearest filtering for pixel art style
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    -- is this needed? math.randomseed(os.time())

    --Setup for simplified state machine
    gStateMachine = StateMachine {
        ['main_menu'] = function() return MainMenuState() end,
        ['pause_menu'] = function() return PauseMenuState() end,
        ['play'] = function() return PlayState() end,
        ['game_over'] = function() return GameOverState() end
    }
    gStateMachine:change('main_menu')

    love.graphics.setFont(gFonts['TitleFont'])
    
    --Init input table for key tracking
    love.keyboard.keysPressed = {}
end

--Resize function for push library, to handle window resizing
function love.resize(w, h)
    push:resize(w, h)
end

--Input recording
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

--Input checking
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    --Run current state update function
    gStateMachine:update(dt)
    --Reset input table after so inputs arent saved across frames
    love.keyboard.keysPressed = {}
end

function love.draw()
    --For virtual resolution scaling
    push:start()

    --Run current state render function
    gStateMachine.current:render()
    
    push:finish()
end