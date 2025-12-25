--[[
    GD50
    Legend of Zelda

    -- Animation Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Animation = Class{}

function Animation:init(def)
    self.frames = def.frames
    self.interval = def.interval
    self.texture = def.texture
    self.looping = def.looping ~= false


    self.timer = 0
    self.currentFrame = 1

    -- used to see if we've seen a whole loop of the animation
    self.timesPlayed = 0
end

function Animation:refresh()
    self.timer = 0
    self.currentFrame = 1
    self.timesPlayed = 0
end

function Animation:update(dt)
    self.timer = self.timer + dt

    if self.timer > self.interval then
        self.timer = self.timer % self.interval
        self.currentFrame = self.currentFrame + 1

        if self.currentFrame > #self.frames then
            self.timesPlayed = self.timesPlayed + 1

            if self.looping then
                self.currentFrame = 1
            else
                self.currentFrame = #self.frames -- stay on last frame
            end
        end
    end
end


function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end