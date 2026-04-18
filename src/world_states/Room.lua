--[[Room
Credit to Colton Ogden's CS50G work for the base structure and functions of this class
Modified to include map and wall generation using noise 
Manages entities and player interactions within the room, including collision and rendering of the world and entities
]]--
Room = Class{}

function Room:init(player)
    self.width  = MAP_WIDTH
    self.height = MAP_HEIGHT

    --self.frozen used to freeze the world for the death animation (only player updates for death animation)
    self.frozen = false

    self.tiles = {}

    self.entities = {}
    self.projectiles = {}

    self.seed_noise_x = love.math.random(1, 100000)
    self.seed_noise_y = love.math.random(1, 100000)

    self.player = player
end


--World generation, uses noise to make irregular shape of dirt floor based on a defined radius (in constants.lua)
function Room:generateWorld()
    local center_x = self.width / 2
    local center_y = self.height / 2
    local base_radius = MAP_PLAYABLE_RADIUS

    --Tone down noise for play area, adjustable
    local noise_scale = 0.05

    for y = 1, self.height do
        self.tiles[y] = {}

        for x = 1, self.width do
            local dx = x - center_x
            local dy = y - center_y
            local distance = math.sqrt(dx * dx + dy * dy)

            local normalized_noise = love.math.noise((x + self.seed_noise_x) * noise_scale,(y + self.seed_noise_y) * noise_scale)
            local adjusted_radius = base_radius + (normalized_noise * 10 - 5)

            --Playable area generation
            if distance <= adjusted_radius then
                local def = TILE_IDS.DARK_GRASS_FLOORS
                self.tiles[y][x] = {
                    is_floor = true,
                    solid = false,
                    sheet = def.sheet,
                    id = def.variants[math.random(#def.variants)]
                }
            --Rest of map is filled with dirt tiles
            else
                self.tiles[y][x] = {
                    is_floor = false,
                    solid = true
                }
                self.tiles[y][x].background = {
                    sheet = TILE_IDS.DIRT_FILLER.sheet,
                    id = TILE_IDS.DIRT_FILLER.variants[math.random(#TILE_IDS.DIRT_FILLER.variants)]
                }
            end
        end
    end

    self:generateWalls()
end

--After getting floors, generate walls based on the adjacent floors
function Room:generateWalls()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]

            if not tile.is_floor then
                local up    = (y > 1)               and self.tiles[y-1][x].is_floor
                local down  = (y < self.height)     and self.tiles[y+1][x].is_floor
                local left  = (x > 1)               and self.tiles[y][x-1].is_floor
                local right = (x < self.width)      and self.tiles[y][x+1].is_floor

                local up_left     = (y > 1 and x > 1)                         and self.tiles[y-1][x-1].is_floor
                local up_right    = (y > 1 and x < self.width)                and self.tiles[y-1][x+1].is_floor
                local down_left   = (y < self.height and x > 1)               and self.tiles[y+1][x-1].is_floor
                local down_right  = (y < self.height and x < self.width)      and self.tiles[y+1][x+1].is_floor

                local variant_name

                if up and left and not up_left then
                    variant_name = "TOP_LEFT_CORNER"
                elseif up and right and not up_right then
                    variant_name = "TOP_RIGHT_CORNER"
                elseif down and left and not down_left then
                    variant_name = "BOTTOM_LEFT_CORNER"
                elseif down and right and not down_right then
                    variant_name = "BOTTOM_RIGHT_CORNER"
                else
                    local mask = 0
                    if up    then mask = mask + 1 end
                    if down  then mask = mask + 2 end
                    if left  then mask = mask + 4 end
                    if right then mask = mask + 8 end

                    variant_name = WALL_MASK_MAP[mask]
                end

                --Since sprite sheet walls have differnt collision shapes, assign collision based on variant (defined in constants.lua)
                if variant_name then
                    local id = TILE_IDS.WALL.variants[variant_name]

                    tile.foreground = {
                        sheet = TILE_IDS.WALL.sheet,
                        id = id
                    }

                    tile.solid = true
                    tile.collision = WALL_COLLISION[id]
                end
            end
        end
    end
end

--Used only for enemy spawn at the moment
function Room:getRandomFloorPosition()
    while true do
        local x = love.math.random(1, self.width)
        local y = love.math.random(1, self.height)
        local tile = self.tiles[y] and self.tiles[y][x]

        if tile and tile.is_floor then
            return (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE
        end
    end
end

--Spawns 3 slime and 2 archers for testing
function Room:generateEntities()
    for i = 1, 3 do
        local enemy_type = 'slime'
        local enemy_spawn_x, enemy_spawn_y = self:getRandomFloorPosition()

        local ent = Enemy {
            room = self,
            max_health = ENTITY_DEFS[enemy_type].max_health,
            health = ENTITY_DEFS[enemy_type].max_health,
            walk_speed = ENTITY_DEFS[enemy_type].walk_speed,
            animations = ENTITY_DEFS[enemy_type].animations,
            x = enemy_spawn_x,
            y = enemy_spawn_y, 
            width = 16,
            height = 16,
            damage = ENTITY_DEFS[enemy_type].damage,
            ranged = ENTITY_DEFS[enemy_type].ranged or false,
            attack_name = ENTITY_DEFS[enemy_type].attack_name,
            ai_profile = ENTITY_DEFS[enemy_type].ai_profile,
            chase_range = ENTITY_DEFS[enemy_type].chase_range,
            attack_range = ENTITY_DEFS[enemy_type].attack_range,
        }

        table.insert(self.entities, ent)
        if DEBUG_MODE then
            DebugLog.log("[Room:generateEntities] Spawned enemy #%d attack=%s ai_profile=%s", #self.entities, tostring(ent.attack_name), tostring(ent.ai and ent.ai ~= nil))
        end
    end

    for i = 1, 2 do
        local enemy_type = 'archer'
        local enemy_spawn_x, enemy_spawn_y = self:getRandomFloorPosition()

        local ent = Enemy {
            room = self,
            max_health = ENTITY_DEFS[enemy_type].max_health,
            health = ENTITY_DEFS[enemy_type].max_health,
            walk_speed = ENTITY_DEFS[enemy_type].walk_speed,
            animations = ENTITY_DEFS[enemy_type].animations,
            x = enemy_spawn_x,
            y = enemy_spawn_y, 
            width = 16,
            height = 16,
            damage = ENTITY_DEFS[enemy_type].damage,
            ranged = ENTITY_DEFS[enemy_type].ranged or false,
            attack_name = ENTITY_DEFS[enemy_type].attack_name,
            ai_profile = ENTITY_DEFS[enemy_type].ai_profile,
            chase_range = ENTITY_DEFS[enemy_type].chase_range,
            attack_range = ENTITY_DEFS[enemy_type].attack_range,
        }

        table.insert(self.entities, ent)
        if DEBUG_MODE then
            DebugLog.log("[Room:generateEntities] Spawned enemy #%d attack=%s ai_profile=%s", #self.entities, tostring(ent.attack_name), tostring(ent.ai and ent.ai ~= nil))
        end
    end
end

--AABB collsion check for wall collision
local function rectsOverlap(ax, ay, aw, ah, bx, by, bw, bh)
    return ax < bx + bw and
           ax + aw > bx and
           ay < by + bh and
           ay + ah > by
end

function Room:collidesWithWall(x, y, w, h)
    local left   = math.floor(x / TILE_SIZE) + 1
    local right  = math.floor((x + w - 1) / TILE_SIZE) + 1
    local top    = math.floor(y / TILE_SIZE) + 1
    local bottom = math.floor((y + h - 1) / TILE_SIZE) + 1

    for ty = top, bottom do
        for tx = left, right do
            local tile = self.tiles[ty] and self.tiles[ty][tx]

            -- outside map counts as solid
            if not tile then
                return true
            end

            if tile.solid then
                local tile_x = (tx - 1) * TILE_SIZE
                local tile_y = (ty - 1) * TILE_SIZE

                -- if no custom collision shape, fall back to full tile
                local collision_rects = tile.collision or {
                    { x = 0, y = 0, width = TILE_SIZE, height = TILE_SIZE }
                }

                for _, rect in ipairs(collision_rects) do
                    local rx = tile_x + rect.x
                    local ry = tile_y + rect.y
                    local rw = rect.width
                    local rh = rect.height

                    if rectsOverlap(x, y, w, h, rx, ry, rw, rh) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

--Debug function to visualize collision boxes of solid tiles
function Room:renderCollisionDebug()
    for ty = 1, self.height do
        for tx = 1, self.width do
            local tile = self.tiles[ty][tx]

            if tile and tile.solid then
                local tile_x = (tx - 1) * TILE_SIZE
                local tile_y = (ty - 1) * TILE_SIZE

                local rects = tile.collision or {
                    { x = 0, y = 0, width = TILE_SIZE, height = TILE_SIZE }
                }

                for _, rect in ipairs(rects) do
                    local rx = tile_x + rect.x
                    local ry = tile_y + rect.y

                    love.graphics.setColor(1, 0, 0, 0.2)
                    love.graphics.rectangle("fill", rx, ry, rect.width, rect.height)

                    love.graphics.setColor(1, 0, 0, 1)
                    love.graphics.rectangle("line", rx, ry, rect.width, rect.height)
                end
            end
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

--Check for wall collision before moving entity, allowing movement along walls (slide) if only one axis is blocked
function Room:moveEntity(entity, dx, dy)
    if not self:collidesWithWall(entity.x + dx, entity.y, entity.width, entity.height) then
        entity.x = entity.x + dx
    end

    if not self:collidesWithWall(entity.x, entity.y + dy, entity.width, entity.height) then
        entity.y = entity.y + dy
    end
end

-- Update room + player
function Room:update(dt)
    -- If frozen, ONLY update player animation (death)
    if self.frozen then
        if self.player then
            self.player:update(dt)
        end
        return
    end
    
    if self.player then
        self.player:update(dt)
    end

    for _, entity in ipairs(self.entities) do
        entity:update(dt)
    end

    --Update for projectiles, check collision with enemies, and remove if inactive
    for i = #self.projectiles, 1, -1 do
        local p = self.projectiles[i]
        if not p.active then
            table.remove(self.projectiles, i)
        else
            --Check projectile collision with player
            if self.player and self.player ~= p.owner and not self.player.dead then
                if self.player:collides(p) then

                    if self.player.invulnerable then
                        p.active = false
                    else
                        self.player:dealDamage(p.damage)
                        p.active = false

                        if self.player.dead then
                            self.frozen = true
                        end

                        self.player:goInvulnerable()
                    end
                end
            end
            --Check collision with enemies, enemies can be hit by other enemies
            for _, entity in ipairs(self.entities) do
                if entity ~= p.owner and entity:collides(p) then
                    if entity.invulnerable then
                        p.active = false
                    else
                        entity:dealDamage(p.damage)
                        if not entity.dead then
                            entity:goInvulnerable(0.5)
                        end
                        p.active = false
                    end
                end
            end
        end
        p:update(dt)
    end

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]
        if entity.remove then
            table.remove(self.entities, i)
        end
    end

    --Check for collision between player and enemies + damage player, also apply invulnerability frames after hit
    if self.player and not self.player.dead then
        for _, entity in ipairs(self.entities) do
            if entity:collides(self.player) and not entity.dead and not self.player.invulnerable then
                self.player:dealDamage(entity.damage or 1)

                if self.player.dead then
                    self.frozen = true
                end

                self.player:goInvulnerable()
            end
        end
    end
end

-- Render all tiles + player
function Room:renderWorld(x_offset, y_offset, tile_size)
    x_offset = x_offset or 0
    y_offset = y_offset or 0
    tile_size = tile_size or 16

    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            local draw_x = x_offset + (x - 1) * tile_size
            local draw_y = y_offset + (y - 1) * tile_size

            if tile.background then
                love.graphics.draw(
                    gTextures[tile.background.sheet],
                    gFrames[tile.background.sheet][tile.background.id],
                    draw_x, draw_y
                )
            end

            if tile.is_floor then
                love.graphics.draw(
                    gTextures[tile.sheet],
                    gFrames[tile.sheet][tile.id],
                    draw_x, draw_y
                )
            end

            if tile.foreground then
                love.graphics.draw(
                    gTextures[tile.foreground.sheet],
                    gFrames[tile.foreground.sheet][tile.foreground.id],
                    draw_x, draw_y
                )
            end
        end
    end
end

--Render entities + health bars, includes hit boxes for debugging entities
function Room:renderEntities()
    for i, entity in ipairs(self.entities) do
        entity:render()

        if entity.state_machine then
            entity.state_machine:render()
        end

        if entity.health and entity.health > 0 then
            love.graphics.setColor(0, 1, 0, 1)
            local w = (entity.health / entity.max_health) * entity.width
            love.graphics.rectangle("fill", entity.x, entity.y - 5, w, 3)
        end

        love.graphics.setColor(1, 1, 1, 1)
    end

    --Rendering for projectiles as well
    for i, projectile in ipairs(self.projectiles) do
        projectile:render()
    end
end


function Room:renderPlayer()
    if self.player then
        self.player:render()
    end
end
