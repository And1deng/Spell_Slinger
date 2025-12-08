Room = Class{}

function Room:init(player)
    -- dimensions MUST be fields on self
    self.width  = MAP_WIDTH
    self.height = MAP_HEIGHT

    -- tile grid
    self.tiles = {}

    -- assigned externally
    self.player = player
end

---------------------------------------------------------
-- Generate a circular overworld
---------------------------------------------------------
function Room:generateCircularOverworld()
    local cx = self.width / 2
    local cy = self.height / 2
    local baseRadius = 5
    
    -- Change to time in future
    love.math.setRandomSeed(12345)
    
    for y = 1, self.height do
        self.tiles[y] = {}
        
        for x = 1, self.width do
            local dx = x - cx
            local dy = y - cy
            local distance = math.sqrt(dx * dx + dy * dy)
            
            -- Generate noise value
            local noiseValue = perlin:noise(x * 0.05, y * 0.05)
            local normalizedNoise = (noiseValue + 1) / 2  -- Convert -1..1 to 0..1
            
            -- Adjust radius with noise
            local radiusVariation = normalizedNoise * 10 - 5  -- -5 to +5
            local adjustedRadius = baseRadius + radiusVariation
            
            if distance <= adjustedRadius then
                -- Floor tile
                local def = TILE_IDS.DARK_GRASS_FLOORS
                self.tiles[y][x] = {
                    isFloor = true,
                    sheet = def.sheet,
                    id = def.variants[math.random(#def.variants)]
                }
            else
                -- Wall/dirt
                self.tiles[y][x] = {
                    isFloor = false
                }
            end
        end
    end
    -- Fill with dirt and generate walls
    self:fillBackgroundWithDirt()
    self:generateWalls()
end

-- Generate dirt base layer

function Room:fillBackgroundWithDirt()
    print("Filling background with dirt...")
    
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            
            if not tile.isFloor then
                -- Every non-floor tile gets dirt background
                -- Store this separately so we can have two layers
                tile.background = {
                    sheet = TILE_IDS.DIRT_FILLER.sheet,
                    id = TILE_IDS.DIRT_FILLER.variants[math.random(#TILE_IDS.DIRT_FILLER.variants)]
                }
            end
        end
    end
end

function Room:generateWalls()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]

            if not tile.isFloor then
                -- Get neighbors
                local up    = (y > 1)               and self.tiles[y-1][x].isFloor
                local down  = (y < self.height)     and self.tiles[y+1][x].isFloor
                local left  = (x > 1)               and self.tiles[y][x-1].isFloor
                local right = (x < self.width)      and self.tiles[y][x+1].isFloor

                local upLeft     = (y > 1 and x > 1)                         and self.tiles[y-1][x-1].isFloor
                local upRight    = (y > 1 and x < self.width)                and self.tiles[y-1][x+1].isFloor
                local downLeft   = (y < self.height and x > 1)               and self.tiles[y+1][x-1].isFloor
                local downRight  = (y < self.height and x < self.width)      and self.tiles[y+1][x+1].isFloor

                -----------------------------------------------------
                -- DIAGONAL FIXES
                -----------------------------------------------------
                if up and left and not upLeft then
                    tile.foreground = {
                        sheet = TILE_IDS.WALL.sheet,
                        id = TILE_IDS.WALL.variants.TOP_LEFT_CORNER
                    }
                    goto continue
                end

                if up and right and not upRight then
                    tile.foreground = {
                        sheet = TILE_IDS.WALL.sheet,
                        id = TILE_IDS.WALL.variants.TOP_RIGHT_CORNER
                    }
                    goto continue
                end

                if down and left and not downLeft then
                    tile.foreground = {
                        sheet = TILE_IDS.WALL.sheet,
                        id = TILE_IDS.WALL.variants.BOTTOM_LEFT_CORNER
                    }
                    goto continue
                end

                if down and right and not downRight then
                    tile.foreground = {
                        sheet = TILE_IDS.WALL.sheet,
                        id = TILE_IDS.WALL.variants.BOTTOM_RIGHT_CORNER
                    }
                    goto continue
                end

                -----------------------------------------------------
                -- NORMAL 16-TILE AUTOTILE MASK
                -----------------------------------------------------
                local mask = 0
                if up    then mask = mask + 1 end
                if down  then mask = mask + 2 end
                if left  then mask = mask + 4 end
                if right then mask = mask + 8 end

                local variantName = WALL_MASK_MAP[mask]

                if variantName then
                    tile.foreground = {
                        sheet = TILE_IDS.WALL.sheet,
                        id = TILE_IDS.WALL.variants[variantName]
                    }
                end

                ::continue::
            end
        end
    end
end

---------------------------------------------------------
-- Update room + player
---------------------------------------------------------
function Room:update(dt)
    if self.player then
        self.player:update(dt)
    end
end

---------------------------------------------------------
-- Render all tiles + player
---------------------------------------------------------
function Room:render(xOffset, yOffset, tileSize)
    xOffset = xOffset or 0
    yOffset = yOffset or 0
    tileSize = tileSize or 16
    
    -- Render in correct order:
    -- 1. Background (dirt) for ALL tiles
    -- 2. Floor tiles (overwrites dirt where there's floor)
    -- 3. Wall foreground (over background dirt)
    
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            local drawX = xOffset + (x - 1) * tileSize
            local drawY = yOffset + (y - 1) * tileSize
            
            -- LAYER 1: Background dirt (for all non-floor tiles)
            if tile.background then
                love.graphics.draw(
                    gTextures[tile.background.sheet],
                    gFrames[tile.background.sheet][tile.background.id],
                    drawX, drawY
                )
            end
            
            -- LAYER 2: Floor tiles (overwrites dirt)
            if tile.isFloor then
                love.graphics.draw(
                    gTextures[tile.sheet],
                    gFrames[tile.sheet][tile.id],
                    drawX, drawY
                )
            end
            
            -- LAYER 3: Wall foreground (over background dirt)
            if tile.foreground then
                love.graphics.draw(
                    gTextures[tile.foreground.sheet],
                    gFrames[tile.foreground.sheet][tile.foreground.id],
                    drawX, drawY
                )
            end
        end
    end
    
    -- Render player on top of everything
    if self.player then
        self.player:render()
    end
end

return Room
