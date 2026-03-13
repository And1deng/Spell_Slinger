--Animation class. Credit to CS50's intro to game development course.

Animation = Class{}

--Init
function Animation:init(def)
    --Help determine when to change frames since some animations will have different intervals
    self.frames = def.frames
    self.interval = def.interval
    self.timer = 0
    self.currentFrame = 1

    --Texture and loop management (looping default true)
    self.texture = def.texture
    self.looping = def.looping ~= false

    --Help with timing and frame tracking
    self.timer = 0
    self.currentFrame = 1

    --Ensure death animation played through once before transitioning to game over screen
    self.timesPlayed = 0
end

--Reset animation to first frame
function Animation:refresh()
    self.timer = 0
    self.currentFrame = 1
    self.timesPlayed = 0
end

--Update. Increment timer, manage frame/interval, and track times played for non-looping animations (death)
function Animation:update(dt)
    self.timer = self.timer + dt

    if self.timer >= self.interval then
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

--Retrieve current frame to Entity:render
function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end