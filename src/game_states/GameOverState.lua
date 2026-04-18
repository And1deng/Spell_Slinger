--[[Game Over State
Displayed when player dies and prompts them to return to main menu with Enter key
]]--

GameOverState = Class{__includes = BaseState}

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('main_menu')
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['TitleFont'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['DefaultFont'])
    love.graphics.printf('Press Enter to return to the Main Menu', 0, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
end