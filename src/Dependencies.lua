Class = require 'lib/class'
push = require 'lib/push'

-- classes
require 'src/StateMachine'
require 'src/constants'
require 'src/Player'
require 'src/Util'

-- game states
require 'src/game_states/BaseState'
require 'src/game_states/MainMenuState'
require 'src/game_states/PlayState'
require 'src/game_states/GameOverState'

-- resources
gTextures = {}
gFrames = {}
gFonts = { 
    ['TitleFont'] = love.graphics.newFont('fonts/alagard.ttf', 35),
    ['DefaultFont'] = love.graphics.newFont('fonts/OldeTome.ttf', 16), 
}
gSounds = {}
