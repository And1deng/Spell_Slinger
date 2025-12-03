Class = require 'lib/class'
push = require 'lib/push'

-- classes
require 'src/StateMachine'
require 'src/constants'
require 'src/Player'
require 'src/Util'
require 'src/BackgroundParallax'

-- game states
require 'src/game_states/BaseState'
require 'src/game_states/MainMenuState'
require 'src/game_states/PlayState'
require 'src/game_states/GameOverState'
require 'src/world_states/Room'

-- resources
gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/temp_tilemap/Tilesets/dark_grass.png'),
    ['walls'] = love.graphics.newImage('graphics/temp_tilemap/Walls/dirt_high_ground.png')

}
gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['walls'] = GenerateQuads(gTextures['walls'], 16, 16)
}
gFonts = { 
    ['TitleFont'] = love.graphics.newFont('fonts/alagard.ttf', 35),
    ['DefaultFont'] = love.graphics.newFont('fonts/OldeTome.ttf', 16), 
}
gSounds = {}
