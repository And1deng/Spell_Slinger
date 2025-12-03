-- Room.lua
-- Generates a simple rectangular room using TILE_IDS

Room = {}
Room.__index = Room

function Room:new(width, height)
    local this = {
        width = width,
        height = height,
        tiles = {} 
    }

    setmetatable(this, Room)

    this:generate()
    return this
end

function Room:generate()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local tileDef = nil

            -- Corners
            if x == 1 and y == 1 then
                tileDef = TILE_IDS.DIRT_WALL_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                tileDef = TILE_IDS.DIRT_WALL_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                tileDef = TILE_IDS.DIRT_WALL_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                tileDef = TILE_IDS.DIRT_WALL_BOTTOM_RIGHT_CORNER

            -- Edges
            elseif x == 1 then
                tileDef = TILE_IDS.DIRT_WALL_LEFT_WALLS
            elseif x == self.width then
                tileDef = TILE_IDS.DIRT_WALL_RIGHT_WALLS
            elseif y == 1 then
                tileDef = TILE_IDS.DIRT_WALL_TOP_WALLS
            elseif y == self.height then
                tileDef = TILE_IDS.DIRT_WALL_BOTTOM_WALLS

            -- Floors
            else
                tileDef = TILE_IDS.DARK_GRASS_FLOORS
            end

            -- Pick a random variant for the tile
            local id = tileDef.variants[math.random(#tileDef.variants)]

            -- Store both id and sheet for rendering
            table.insert(self.tiles[y], {
                id = id,
                sheet = tileDef.sheet
            })
        end
    end
end

function Room:render(xOffset, yOffset, tileSize)
    xOffset = xOffset or 0
    yOffset = yOffset or 0
    tileSize = tileSize or 16

    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]

            love.graphics.draw(
                gTextures[tile.sheet],
                gFrames[tile.sheet][tile.id],
                xOffset + (x - 1) * tileSize,
                yOffset + (y - 1) * tileSize
            )
        end
    end
end

return Room
