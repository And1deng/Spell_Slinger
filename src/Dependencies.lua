--Class includes
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

--General resources
require 'src/StateMachine'
require 'src/constants'
require 'src/Entity'
require 'src/Player'
require 'src/Util'
require 'src/BackgroundParallax'
require 'src/Animation'
require 'src/Projectile'
require 'src/Hitbox'

--Game states
require 'src/game_states/BaseState'
require 'src/game_states/MainMenuState'
require 'src/game_states/PauseMenuState'
require 'src/game_states/PlayState'
require 'src/game_states/GameOverState'
require 'src/world_states/Room'

--General entity states
require 'src/entity_states/EntityIdleState'
require 'src/entity_states/EntityWalkState'
require 'src/entity_states/EntityAttackState'
require 'src/entity_states/EntityDeathState'
--Enemy base states & AI
require 'src/entity_states/enemies/Enemy'
require 'src/entity_states/enemies/BaseEnemyAI'
require 'src/entity_states/enemies/BaseEnemyIdle'
require 'src/entity_states/enemies/BaseEnemyAttack'
require 'src/entity_states/enemies/BaseEnemyAggro'
require 'src/entity_states/enemies/BaseEnemyDeath'
--Player states
require 'src/entity_states/player/PlayerIdleState'
require 'src/entity_states/player/PlayerWalkState'
require 'src/entity_states/player/PlayerDodgeState'
require 'src/entity_states/player/PlayerDeathState'

--Defintion files
require 'src/entity_definitions'
require 'src/attack_definitions'

--Texture + UI resources
gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/temp_tilemap/Tilesets/dark_grass.png'),
    ['filler'] = love.graphics.newImage('graphics/temp_tilemap/Tilesets/mud.png'),
    ['walls'] = love.graphics.newImage('graphics/temp_tilemap/Walls/dirt_high_ground.png'),
    
    --Player Sprites
    ['character-walk-left'] = love.graphics.newImage('graphics/temp_player/Side animations/spr_player_left_walk.png'),
    ['character-walk-right'] = love.graphics.newImage('graphics/temp_player/Side animations/spr_player_right_walk.png'),
    ['character-walk-up'] = love.graphics.newImage('graphics/temp_player/Back animations/spr_player_back_walk.png'),
    ['character-walk-down'] = love.graphics.newImage('graphics/temp_player/Front animations/spr_player_front_walk.png'),
    ['character-death'] = love.graphics.newImage('graphics/temp_player/Special animations/spr_player_death.png'),

    --Spells
    ['fireball'] = love.graphics.newImage('graphics/projectiles/fireball.png'),

    --Enemies
    ['slime'] = love.graphics.newImage('graphics/temp_enemy/Enemies_Green_Slime.png')
}
gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['filler'] = GenerateQuads(gTextures['filler'], 16, 16),
    ['walls'] = GenerateQuads(gTextures['walls'], 16, 16),

    --Player Sprites
    ['character-walk-left'] = GenerateQuads(gTextures['character-walk-left'], 64, 64),
    ['character-walk-right'] = GenerateQuads(gTextures['character-walk-right'], 64, 64),
    ['character-walk-up'] = GenerateQuads(gTextures['character-walk-up'], 64, 64),
    ['character-walk-down'] = GenerateQuads(gTextures['character-walk-down'], 64, 64),
    ['character-death'] = GenerateQuads(gTextures['character-death'], 64, 64),

    --Spells
    ['fireball'] = GenerateQuads(gTextures['fireball'], 16, 16),

    --Enemies
    ['slime'] = GenerateQuads(gTextures['slime'], 16, 16)
}
gFonts = { 
    ['TitleFont'] = love.graphics.newFont('fonts/alagard.ttf', 35),
    ['DefaultFont'] = love.graphics.newFont('fonts/OldeTome.ttf', 16), 
    ['DebugFont'] = love.graphics.newFont('fonts/ARIAL.ttf', 16), 
}
gSounds = {}
