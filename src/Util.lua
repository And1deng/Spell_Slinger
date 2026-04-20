--[[Util
Credit to Colton Ogden's CS50G work for the GenerateQuads function
Generates quads from a sprite sheet numbered left to right, top to bottom. Used for splitting sprites for any animations.
]]--

--Given a sprite sheet, and tile width and height, generate sprite quads
function GenerateQuads(atlas, tile_w, tile_h)
    local sheet_w = atlas:getWidth()
    local sheet_h = atlas:getHeight()

    local sheet_columns = sheet_w / tile_w
    local sheet_rows = sheet_h / tile_h

    local quads = {}
    local id = 1

    --Generates Quads from a sprite sheet numbered left to right, top to bottom.
    for y = 0, sheet_rows - 1 do
        for x = 0, sheet_columns - 1 do
            quads[id] = love.graphics.newQuad(
                x * tile_w,
                y * tile_h,
                tile_w,
                tile_h,
                sheet_w,
                sheet_h
            )
            id = id + 1
        end
    end

    return quads
end
