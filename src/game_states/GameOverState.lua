GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.timer = 0
end

function GameOverState:update(dt)
    -- Return to main menu on Enter
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