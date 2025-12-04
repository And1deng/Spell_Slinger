PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0

    local mapCenterX = (MAP_WIDTH * TILE_SIZE) / 2
    local mapCenterY = (MAP_HEIGHT * TILE_SIZE) / 2

   self.player = Player {
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,
        x = mapCenterX - 8,
        y = mapCenterY - 8,
        width = 16,
        height = 16,
    }
    self.room = Room(self.player)
    self.room:generateCircularOverworld()

    self.player.stateMachine = StateMachine {
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['walk'] = function() return PlayerWalkState(self.player) end
    }
    self.player:changeState('idle')
end

function PlayState:updateCamera()
    -- Get map boundaries in pixels
    local mapWidthPixels = self.room.width * TILE_SIZE
    local mapHeightPixels = self.room.height * TILE_SIZE
    
    -- Calculate ideal camera position (centered on player)
    local targetX = self.player.x - VIRTUAL_WIDTH / 2 + self.player.width / 2
    local targetY = self.player.y - VIRTUAL_HEIGHT / 2 + self.player.height / 2
    
    -- Clamp to map boundaries
    self.camX = math.max(0, math.min(targetX, mapWidthPixels - VIRTUAL_WIDTH))
    self.camY = math.max(0, math.min(targetY, mapHeightPixels - VIRTUAL_HEIGHT))
    
    -- Debug print to see what's happening
    print(string.format("Player: (%.1f, %.1f), Camera: (%.1f, %.1f), Target: (%.1f, %.1f)", 
        self.player.x, self.player.y, self.camX, self.camY, targetX, targetY))
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    self.player:update(dt)

    -- Update the room (which updates the player inside)
    self.room:update(dt)

    -- Update the camera **after** player has moved
    self:updateCamera()
end

function PlayState:render()
    -- FIRST: Render everything with camera transformation
    love.graphics.push()
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    
    if self.room then
        self.room:render(0, 0, TILE_SIZE)  -- This renders room AND player at world coords
    end
    
    love.graphics.pop()
    
    -- SECOND: Render UI elements at screen coordinates (no camera transform)
    love.graphics.setFont(gFonts['DebugFont'])
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Debug info at screen coordinates
    love.graphics.print("Player: " .. math.floor(self.player.x) .. ", " .. math.floor(self.player.y), 10, 10)
    love.graphics.print("Camera: " .. math.floor(self.camX) .. ", " .. math.floor(self.camY), 10, 30)
    
    -- Also show player's screen position
    local screenX = self.player.x - self.camX
    local screenY = self.player.y - self.camY
    love.graphics.print("Screen Pos: " .. math.floor(screenX) .. ", " .. math.floor(screenY), 10, 50)
end