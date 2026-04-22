--[[PlayState
Credit to CS50's intro to game development course
Manages the main game loop, including player updates, room updates, camera movement, and UI rendering
Also handles player death transition and game over state change
]]--
--Manages the camera, UI, and main game loop
PlayState = Class{__includes = BaseState}

--Init only handles UI positions since they do not need to be reset
function PlayState:init()
    self.health_bar_w = 200
    self.health_bar_h = 20
    self.health_bar_x = VIRTUAL_WIDTH / 2 - self.health_bar_w / 2
    self.health_bar_y = VIRTUAL_HEIGHT - 30
    self.enemy_types = { 'slime', 'archer', 'mummy' }

    if DEBUG_MODE then
        self.score_text_x = 10
        self.score_text_y = 30
    else
        self.score_text_x = 10
        self.score_text_y = 10
    end
end

function PlayState:enter(params)
    params = params or {}

    if params.reset == true then
        self:reset()
    end
end

function PlayState:exit()
    if self.spawn_timer then
        self.spawn_timer:remove()
        self.spawn_timer = nil
    end
end

function PlayState:getRandomEnemyType()
    return self.enemy_types[love.math.random(#self.enemy_types)]
end

--Every "ENEMY_SPAWN_WAVES_PER_GROWTH" waves, increase number of enemies spawned determined by "spawn_count"
function PlayState:spawnEnemyWave()
    if not self.room or self.player.dead then
        return
    end

    self.spawn_wave = self.spawn_wave + 1

    --Prevent decimals
    local growth_steps = math.floor(self.spawn_wave / ENEMY_SPAWN_WAVES_PER_GROWTH)

    local spawn_count = ENEMY_SPAWN_START_COUNT + growth_steps * ENEMY_SPAWN_GROWTH_RATE
    for i = 1, spawn_count do
        self.room:generateEntities(self:getRandomEnemyType(), 1)
    end
end

function PlayState:startSpawnTimer()
    if self.spawn_timer then
        self.spawn_timer:remove()
    end

    self.spawn_timer = Timer.every(ENEMY_SPAWN_INTERVAL_SECONDS, function()
        self:spawnEnemyWave()
    end)
end

--Room generation and player reset in here so game can restart when player dies and re enters from main menu
function PlayState:reset()
    if self.spawn_timer then
        self.spawn_timer:remove()
        self.spawn_timer = nil
    end

    self.score = 0
    self.final_cam_x = 0
    self.final_cam_y = 0
    self.transition_alpha = 0
    self.spawn_wave = 0

    local map_center_x = (MAP_WIDTH * TILE_SIZE) / 2
    local map_center_y = (MAP_HEIGHT * TILE_SIZE) / 2

    self.player = Player {
        max_health = ENTITY_DEFS['player'].max_health,
        health = ENTITY_DEFS['player'].max_health,
        walk_speed = ENTITY_DEFS['player'].walk_speed,
        animations = ENTITY_DEFS['player'].animations,
        x = map_center_x - 8,
        y = map_center_y - 8,
        offset_x = ENTITY_DEFS['player'].offset_x,
        offset_y = ENTITY_DEFS['player'].offset_y,
        width = 16,
        height = 16,
    }

    self.player.state_machine = StateMachine {
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['walk'] = function() return PlayerWalkState(self.player) end,
        ['dodge'] = function() return PlayerDodgeState(self.player) end,
        ['death'] = function() return PlayerDeathState(self.player) end,
    }

    self.room = Room(self.player, 
        function(points)
            self:addScore(points)
        end
    )

    self.player.room = self.room
    self:updateCamera()
    

    self.room:generateWorld()
    if SPAWN_ENEMIES == true then 
        self.room:generateEntities('slime', 3)
        self.room:generateEntities('archer', 3)
        self.room:generateEntities('mummy', 3)
        self:startSpawnTimer()
    end

    self.player:changeState('idle')
    self.player:changeAnimation('idle_down')
end

function PlayState:addScore(points)
    
    self.score = self.score + points
end

--Move camera to follow player with map clamping to prevent showing areas outside of map bounds
function PlayState:updateCamera()
    local map_width = self.room.width * TILE_SIZE
    local map_height = self.room.height * TILE_SIZE

    local cam_center_x = self.player.x - VIRTUAL_WIDTH / 2 + self.player.width / 2
    local cam_center_y = self.player.y - VIRTUAL_HEIGHT / 2 + self.player.height / 2

    self.final_cam_x = math.max(0, math.min(cam_center_x, map_width - VIRTUAL_WIDTH))
    self.final_cam_y = math.max(0, math.min(cam_center_y, map_height - VIRTUAL_HEIGHT))
end

--Updates for Room (player is managed in room) + Camera, also plays death transition
function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('pause_menu')
        return
    end

    self.room:update(dt)
    self:updateCamera()

    if self.player.dead then
        self.transition_alpha = math.min(1, self.transition_alpha + dt)

        if self.transition_alpha >= 1 then
            gStateMachine:change('game_over', {score = self.score})

        end

        return
    end


    Timer.update(dt)
end

--Render font + health bar UI, also contains debug player hit box for debugging purposes
function PlayState:renderUI()
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", self.health_bar_x, self.health_bar_y, self.health_bar_w, self.health_bar_h)

    love.graphics.setColor(0, 1, 0, 1)
    local healthFill = (self.player.health / self.player.max_health) * self.health_bar_w
    love.graphics.rectangle("fill", self.health_bar_x, self.health_bar_y, healthFill, self.health_bar_h)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", self.health_bar_x, self.health_bar_y, self.health_bar_w, self.health_bar_h)

    love.graphics.setFont(gFonts['DefaultFont'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(string.format("Score: %d", self.score), self.score_text_x, self.score_text_y)

    --Display for debug player position
    if DEBUG_MODE then
        love.graphics.setFont(gFonts['DebugFont'])
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(string.format("Player: %.1f, %.1f", self.player.x, self.player.y), 10, 10)
    end
end

function PlayState:render()
    love.graphics.push()
    love.graphics.translate(-math.floor(self.final_cam_x), -math.floor(self.final_cam_y))

    self.room:renderWorld(0, 0, TILE_SIZE)
    self.room:renderEntities()

    if DEBUG_MODE then
        self.room:renderCollisionDebug()
    end

    love.graphics.pop()

    if self.player.dead then
        love.graphics.setColor(0, 0, 0, self.transition_alpha)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.push()
    love.graphics.translate(-math.floor(self.final_cam_x), -math.floor(self.final_cam_y))
    self.room:renderPlayer()
    love.graphics.pop()

    self:renderUI()

    self.player:renderCast()
end

--Camera getter for Player.lua to use for spell auto-aim system
function PlayState:getCamera()
    return self.final_cam_x, self.final_cam_y
end
