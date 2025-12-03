--Spell Slinger--

require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('SpellSlinger')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.graphics.setFont(gFonts['TitleFont'])

    gStateMachine = StateMachine {
        ['main_menu'] = function() return MainMenuState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('main_menu')

    love.keyboard.keysPressed = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end