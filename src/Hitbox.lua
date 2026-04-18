--[[Hitbox
Credit to Colton Ogden's CS50G work
]]--
Hitbox = Class{}

function Hitbox:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end