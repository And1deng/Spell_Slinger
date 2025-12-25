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

    -- 0 is the top, 1 is the bottom
    if love.keyboard.wasPressed('up') and selected_option >= 0 then
        selected_option = selected_option - 1
    elseif love.keyboard.wasPressed('down') and selected_option <= 1 then
        selected_option = selected_option + 1
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
    love.graphics.printf('Settings', 2, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'center')

        love.graphics.setColor(34/255, 34/255, 34/255, 1)

    if selected_option == 2 then
        love.graphics.setColor(153, 0, 0, 1)
    end
    love.graphics.printf('Exit', 2, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')
end