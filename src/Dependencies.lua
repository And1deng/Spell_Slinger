--[[Dependencies
Contains all the required files
Libraries
General Resources (entities, states, utilities, etc.)
Game states
Entity states (player and enemy)
Definitions
Debug logging utility
Defined texteures, frames, and fonts for easy access throughout the game
]]--
--Class includes
Class = require 'lib/class'
push = require 'lib/push'

--General resources
require 'src/StateMachine'
require 'src/constants'
require 'src/Entity'
require 'src/Player'
require 'src/Util'
require 'src/BackgroundParallax'
require 'src/Animation'
require 'src/Projectile'

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
require 'src/entity_states/enemies/BaseEnemyAggroAI'
require 'src/entity_states/enemies/BaseEnemyDeath'
--Player states
require 'src/entity_states/player/PlayerIdleState'
require 'src/entity_states/player/PlayerWalkState'
require 'src/entity_states/player/PlayerDodgeState'
require 'src/entity_states/player/PlayerDeathState'

--Defintion files
require 'src/entity_definitions'
require 'src/attack_definitions'

--Debug logging
DebugLog = require 'src/DebugLog'

--Texture + UI resources
gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/temp_tilemap/Tilesets/dark_grass.png'),
    ['filler'] = love.graphics.newImage('graphics/temp_tilemap/Tilesets/mud.png'),
    ['walls'] = love.graphics.newImage('graphics/temp_tilemap/Walls/dirt_high_ground.png'),
    
    --Player Sprites
    ['character_walk_left'] = love.graphics.newImage('graphics/temp_player/Side animations/spr_player_left_walk.png'),
    ['character_walk_right'] = love.graphics.newImage('graphics/temp_player/Side animations/spr_player_right_walk.png'),
    ['character_walk_up'] = love.graphics.newImage('graphics/temp_player/Back animations/spr_player_back_walk.png'),
    ['character_walk_down'] = love.graphics.newImage('graphics/temp_player/Front animations/spr_player_front_walk.png'),
    ['character_death'] = love.graphics.newImage('graphics/temp_player/Special animations/spr_player_death.png'),

    --Attacks
    ['fireball'] = love.graphics.newImage('graphics/projectiles/fireball.png'),
    ['ice_shard'] = love.graphics.newImage('graphics/projectiles/ice_shard.png'),
    ['boulder'] = love.graphics.newImage('graphics/projectiles/boulder.png'),
    ['arrow'] = love.graphics.newImage('graphics/projectiles/arrow.png'),
    --Enemies
    ['slime'] = love.graphics.newImage('graphics/temp_enemy/Enemies_Green_Slime.png'),
    ['archer'] = love.graphics.newImage('graphics/temp_enemy/Enemies_Archer.png')
}
gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['filler'] = GenerateQuads(gTextures['filler'], 16, 16),
    ['walls'] = GenerateQuads(gTextures['walls'], 16, 16),

    --Player Sprites
    ['character_walk_left'] = GenerateQuads(gTextures['character_walk_left'], 64, 64),
    ['character_walk_right'] = GenerateQuads(gTextures['character_walk_right'], 64, 64),
    ['character_walk_up'] = GenerateQuads(gTextures['character_walk_up'], 64, 64),
    ['character_walk_down'] = GenerateQuads(gTextures['character_walk_down'], 64, 64),
    ['character_death'] = GenerateQuads(gTextures['character_death'], 64, 64),

    --Attacks
    ['fireball'] = GenerateQuads(gTextures['fireball'], 16, 16),
    ['arrow'] = GenerateQuads(gTextures['arrow'], 16, 16),
    
    --Enemies
    ['slime'] = GenerateQuads(gTextures['slime'], 16, 16),
    ['archer'] = GenerateQuads(gTextures['archer'], 16, 16)
}
gFonts = { 
    ['TitleFont'] = love.graphics.newFont('fonts/alagard.ttf', 35),
    ['DefaultFont'] = love.graphics.newFont('fonts/dungeon-mode.ttf', 16), 
    ['DebugFont'] = love.graphics.newFont('fonts/ARIAL.ttf', 16), 
}
