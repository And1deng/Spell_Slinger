BackgroundParallax = Class{}

function BackgroundParallax:init()
    self.layers = {
        { image = love.graphics.newImage("graphics/temp_background/dark_forest_1.png"),  speed = 20, x = 0 },
        { image = love.graphics.newImage("graphics/temp_background/dark_forest_2.png"),  speed = 23, x = 0 },
        { image = love.graphics.newImage("graphics/temp_background/dark_forest_3.png"), speed = 25, x = 0 },
        { image = love.graphics.newImage("graphics/temp_background/dark_forest_4.png"), speed = 28, x = 0 },
        { image = love.graphics.newImage("graphics/temp_background/dark_forest_5.png"), speed = 30, x = 0 }
    }
end

function BackgroundParallax:update(dt)
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
