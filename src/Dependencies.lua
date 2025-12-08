Class = require 'lib/class'
push = require 'lib/push'

-- resources
require 'src/StateMachine'
require 'src/constants'
require 'src/Entity'
require 'src/Player'
require 'src/Util'
require 'src/BackgroundParallax'
require 'src/perlin'

-- game states
require 'src/game_states/BaseState'
require 'src/game_states/MainMenuState'
require 'src/game_states/PlayState'
require 'src/game_states/GameOverState'
require 'src/world_states/Room'

-- entity states
require 'src/entity_states/EntityIdleState'
require 'src/entity_states/EntityWalkState'

-- player states
require 'src/entity_states/player/PlayerIdleState'
require 'src/entity_states/player/PlayerWalkState'

-- data
require 'src/entity_definitions'

-- resources
gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/temp_tilemap/Tilesets/dark_grass.png'),
    ['filler'] = love.graphics.newImage('graphics/temp_tilemap/Tilesets/mud.png'),
    ['walls'] = love.graphics.newImage('graphics/temp_tilemap/Walls/dirt_high_ground.png')

}
gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['filler'] = GenerateQuads(gTextures['filler'], 16, 16),
    ['walls'] = GenerateQuads(gTextures['walls'], 16, 16)
}
gFonts = { 
    ['TitleFont'] = love.graphics.newFont('fonts/alagard.ttf', 35),
    ['DefaultFont'] = love.graphics.newFont('fonts/OldeTome.ttf', 16), 
    ['DebugFont'] = love.graphics.newFont('fonts/ARIAL.ttf', 16), 
}
gSounds = {}
