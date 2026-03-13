--Background parallax class. Manages multiple layers of background images that scroll at different speeds to create a parallax effect.
BackgroundParallax = Class{}

function BackgroundParallax:init()
    --Layer definitions and speeds. Can change x if and offset is needed
    self.layers = {
        { image = love.graphics.newImage("graphics/temp_background/dark_forest_1.png"),  speed = 20, x = 0 },
        { image = love.graphics.newImage("graphics/temp_background/dark_forest_2.png"),  speed = 23, x = 0 },
        { image = love.graphics.newImage("graphics/temp_background/dark_forest_3.png"), speed = 25, x = 0 },
        { image = love.graphics.newImage("graphics/temp_background/dark_forest_4.png"), speed = 28, x = 0 },
        { image = love.graphics.newImage("graphics/temp_background/dark_forest_5.png"), speed = 30, x = 0 }
    }
end

function BackgroundParallax:update(dt)
    --Move each layer by unique speed, and reset x to 0 when the image has fully scrolled for seamless loops.
    for _, layer in ipairs(self.layers) do
        layer.x = layer.x - layer.speed * dt
        if layer.x <= -layer.image:getWidth() then
            layer.x = 0
        end
    end
end

function BackgroundParallax:render()
    for _, layer in ipairs(self.layers) do
        love.graphics.draw(layer.image, layer.x, 0)
        love.graphics.draw(layer.image, layer.x + layer.image:getWidth(), 0)
    end
end
