--[[Animation
Credit to Colton Ogden's CS50G work for the base structure and functions of this class

]]--
Animation = Class{}

--Init
function Animation:init(def)
    --Help determine when to change frames since some animations will have different intervals or # of frames
    self.frames = def.frames
    self.interval = def.interval
    self.timer = 0
    self.current_frame = 1
    self.texture = def.texture
    self.flip = def.flip or false
    self.looping = def.looping or false
    
    --Ensure death animation played through once before transitioning to game over screen
    self.times_played = 0
end

--Reset timer + animation to first frame
function Animation:refresh()
    self.timer = 0
    self.current_frame = 1
    self.times_played = 0
end

function Animation:update(dt)
    self.timer = self.timer + dt

    if self.timer >= self.interval then
        self.timer = self.timer % self.interval
        self.current_frame = self.current_frame + 1

        if self.current_frame > #self.frames then
            self.times_played = self.times_played + 1

            if self.looping then
                self.current_frame = 1
            else
                self.current_frame = #self.frames -- stay on last frame
            end
        end
    end
end

--Retrieve current frame to Entity:render
function Animation:getCurrentFrame()
    return self.frames[self.current_frame]
end