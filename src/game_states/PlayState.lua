PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0

    local mapCenterX = (MAP_WIDTH * TILE_SIZE) / 2
    local mapCenterY = (MAP_HEIGHT * TILE_SIZE) / 2

    self.player = Player { --Need to reset health on entering from main menu
        max_health = ENTITY_DEFS['player'].max_health,
        health = ENTITY_DEFS['player'].max_health,
        walk_speed = ENTITY_DEFS['player'].walk_speed,
        animations = ENTITY_DEFS['player'].animations,
        x = mapCenterX - 8,
        y = mapCenterY - 8,
        width = 16,
        height = 16,
    }

    self.room = Room(self.player)
    self.player.room = self.room
    self.room:generateCircularOverworld()

    self.player.state_machine = StateMachine {
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['walk'] = function() return PlayerWalkState(self.player) end,
        ['dodge'] = function() return PlayerDodgeState(self.player) end,
        ['death'] = function() return PlayerDeathState(self.player) end,
    }
    self.player:change_state('idle')

    --UI elements
    healthBarWidth = 200
    healthBarHeight = 20
    healthBarX = VIRTUAL_WIDTH / 2 - healthBarWidth / 2
    healthBarY = VIRTUAL_HEIGHT - 40
    self.transitionAlpha = 0
end

function PlayState:enter()
    self.player.health = self.player.max_health
    self.player.dead = false
    self.transitionAlpha = 0
    self.player:change_state('idle')
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
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('pause_menu')
        return
    end

    self.room:update(dt)
    self:updateCamera()

    if self.player.dead then
        local anim = self.player.current_animation

        if anim and anim.timesPlayed > 0 then
            self.transitionAlpha = math.min(1, self.transitionAlpha + dt)

            if self.transitionAlpha >= 1 then
                gStateMachine:change('game_over')
            end
        end

        return
    end
end


function PlayState:renderUI()
    love.graphics.setFont(gFonts['DebugFont'])

    -- health bar
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", healthBarX, healthBarY, healthBarWidth, healthBarHeight)

    love.graphics.setColor(0, 1, 0, 1)
    local hw = (self.player.health / self.player.max_health) * healthBarWidth
    love.graphics.rectangle("fill", healthBarX, healthBarY, hw, healthBarHeight)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", healthBarX, healthBarY, healthBarWidth, healthBarHeight)

    -- DEBUG: player position
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(
        string.format("Player: %.1f, %.1f", self.player.x, self.player.y),
        10,
        10
    )
end

function PlayState:render()
    -- ===== WORLD =====
    love.graphics.push()
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.room:renderWorld(0, 0, TILE_SIZE)
    self.room:renderEntities()

    love.graphics.pop()

    -- ===== FADE (between world & player) =====
    if self.player.dead then
        love.graphics.setColor(0, 0, 0, self.transitionAlpha)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- ===== PLAYER (always visible) =====
    love.graphics.push()
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    self.room:renderPlayer()
    love.graphics.pop()

    -- ===== UI =====
    self:renderUI()

    -- SPELL CAST INPUTS (screen-space)
    self.player:render_cast()
end

--Camera getter for Player.lua to use for spell auto-aim system
function PlayState:get_camera()
    return self.camX, self.camY
end