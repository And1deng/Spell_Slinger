PauseMenuState = Class{__includes = BaseState}

local selected_option = 0

function PauseMenuState:init()
    self.background = BackgroundParallax()
end

function PauseMenuState:update(dt)
    self.background:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        selected_option = selected_option == 0 and 1 or 0
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if selected_option == 0 then
            gStateMachine:change('play') 
        else --Need to add settings later
            love.event.quit()
        end
    end
end

function PauseMenuState:render()
    self.background:render()
    
    love.graphics.setFont(gFonts['TitleFont'])
    love.graphics.setColor(255, 0, 0, 1)
    love.graphics.printf('Paused', 2, VIRTUAL_HEIGHT / 2 - 70, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['DefaultFont'])

    --20 px between each option
    love.graphics.setColor(34/255, 34/255, 34/255, 1)

    if selected_option == 0 then
        love.graphics.setColor(153, 0, 0, 1)
    end

    love.graphics.printf('Continue', 2, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(34/255, 34/255, 34/255, 1)

    if selected_option == 1 then
        love.graphics.setColor(153, 0, 0, 1)
    end

    love.graphics.printf('Exit', 2, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(34/255, 34/255, 34/255, 1)
end