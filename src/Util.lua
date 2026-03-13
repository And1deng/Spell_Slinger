--Util. Credit to CS50's intro to game development course. 

--Given a sprite sheet, and tile width and height, generate sprite quads
function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth()
    local sheetHeight = atlas:getHeight()

    local sheetColumns = sheetWidth / tileWidth
    local sheetRows = sheetHeight / tileHeight

    local quads = {}
    local id = 1

    --Generates Quads from a sprite sheet numbered left to right, top to bottom.
    for y = 0, sheetRows - 1 do
        for x = 0, sheetColumns - 1 do
            quads[id] = love.graphics.newQuad(
                x * tileWidth,
                y * tileHeight,
                tileWidth,
                tileHeight,
                sheetWidth,
                sheetHeight
            )
            id = id + 1
        end
    end

    return quads
end
