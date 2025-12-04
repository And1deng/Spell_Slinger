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
    local radius = math.min(self.width, self.height) * 0.49
    local radiusSq = radius * radius

    for y = 1, self.height do
        self.tiles[y] = {}

        for x = 1, self.width do

            local dx = x - cx
            local dy = y - cy
            local distSq = dx * dx + dy * dy

            if distSq <= radiusSq then
                -- INSIDE CIRCLE = grass variants
                local def = TILE_IDS.DARK_GRASS_FLOORS
                local variant = def.variants[math.random(#def.variants)]

                self.tiles[y][x] = {
                    isFloor = true,
                    sheet = def.sheet,
                    id = variant
                }

            else
                -- OUTSIDE CIRCLE = void
                self.tiles[y][x] = {
                    isFloor = false,
                    sheet = nil,
                    id = nil
                }
            end
        end
    end

    -- auto–place borders around the circle
    self:generateBorderWalls()
end

---------------------------------------------------------
-- Generate walls around circle boundary
---------------------------------------------------------
function Room:generateBorderWalls()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]

            if not tile.isFloor then
                -- Check if touching a floor tile
                local touching =
                    (self.tiles[y-1] and self.tiles[y-1][x] and self.tiles[y-1][x].isFloor) or
                    (self.tiles[y+1] and self.tiles[y+1][x] and self.tiles[y+1][x].isFloor) or
                    (self.tiles[y][x-1] and self.tiles[y][x-1].isFloor) or
                    (self.tiles[y][x+1] and self.tiles[y][x+1].isFloor)

                if touching then
                    local def = TILE_IDS.DIRT_WALL_TOP_WALLS
                    tile.sheet = def.sheet
                    tile.id = def.variants[math.random(#def.variants)]
                end
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
    
    -- Render tiles at offset positions
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            if tile.sheet and tile.id then
                love.graphics.draw(
                    gTextures[tile.sheet],
                    gFrames[tile.sheet][tile.id],
                    xOffset + (x - 1) * tileSize,  -- This should work
                    yOffset + (y - 1) * tileSize   -- This should work
                )
            end
        end
    end
    
    -- Render player at its WORLD coordinates (not offset)
    if self.player then
        self.player:render()
    end
end

return Room
