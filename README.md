# Spell Slinger
A 2D top-down survival game built in Lua and the LOVE2D framework. This project was based on the CS50's Introduction To Game Development Lecture and built for personal learning and to explore game architecture such as state machines, object management, enemy AI, and world generation. Several files, such as base state machine, animation, and entity structure, were adapted from the coursework.

The player can cast spells using arrow-key sequences and defeat enemies. Along with that, players have dodge movement to avoid enemy attacks. As time passes, more enemies spawn, and the waves become more difficult to clear out. The project also implements an extensible game architecture that allows new spells, enemies, and enemy AI behaviors to be easily added. 

![Gameplay Demo](assets/demo.gif)

## Technical Highlights
### World Generation
The world is generated via a base circular playing area adjusted via a seeded Perlin noise function to produce a circular playable area with smooth edges. Tiles are determined to be floor or wall by using their distance in a formula: 
MAP_PLAYABLE_RADIUS + love.math.noise(tile_x + seed_x * scale, tile_y + seed_y * scale) * amplitude
The scale is utilized to smoothen out edges even more, and the amplitude to adjust the values to a [-5,10] range is added to create negative crevices along with outward expansion. Tiles within that radius are marked as floor, whereas others are marked as solid.
Once the play area is made, the walls are generated along the edges, determined by a bitmask in WALL_MASK_MAP. Each wall would check its neighbors to determine which wall is needed to best encapsulate the area. 

### State Machines
The game and entities are controlled through state machines. The StateMachine class caches instances of new states to void unnecessary re-instantiation of states when there are state changes. BaseState defines the main interface between all the states. EntityIdleState, EntityWalkState, EntityAttackState, and EntityDeathState define all the shared entity behavior and are inherited and expanded upon for specific player or enemy behavior.

### Entity and Attack Definitions
Spells, enemies, and attacks are all defined in attack_definitions.lua and entity_definitions.lua to be easily modifiable as needed. Adding new spells, enemies, or attacks requires only a small modification in the code and a new entry in these definition files. The onCast (for player) or onFire(for enemies) allows the projectile definitions to be defined uniquely.

### Enemy AI
As of now, there are two AI behavior implementated and defined in an ai_profile field. BaseEnemyAI handles the patrolling behavior that all enemies utilize. BaseEnemyAggroAI is a more advanced version that has enemies patrol when the player is not in range, but chase or attack when the player is.

### Spell Casting
Spells are cast through a three-key directional input sequence within a timeout window of 2 seconds. These inputs are stored in a rolling buffer that is compared to the spells defined in ATTACK_DEFS in the attack_definitions.lua file. Once a valid sequence is found, it enters a windup period and is cast once the delay is finished. The delay is included for balancing and preventing the spamming of high-damage spells

### Auto Aim
Since the player will be using the arrow keys and WASD, the spells are aimed automatically using playerGetNearestTargetVector. This function checkes the room for the nearest entity that is on screen and returns a direction vector towards the nearest enemy within a max range. If no valid targets are present, the spell is cast in the player's facing direction instead.

## Requirements 

Windows
LOVE2D

## Build Instructions
Open the root file in the terminal and run "love ."

## Controls

### WASD movement
UP, DOWN, LEFT, RIGHT for spell casting
As of now, there are only three spells

### Spells:

FIREBALL - UP UP UP
ICE SHARD - RIGHT RIGHT RIGHT
BOULDER - DOWN DOWN DOWN

## Potential Extensions

If I were to continue development, the next steps would include: 

Death animations for archer and mummy enemies use placeholder animations since the free sprite did not include them
Implementation of control modifications has not been implemented yet, but is set up for it
Only a single room for now, more rooms or procedurally generated dungeons would be ideal
More spells and variation in spells (healing, evasion, ally summoning, etc.)
Boss/Modified enemies would add more variation in play
No audio/sound effects
The debugging log only covers certain parts, but would ideally cover more systems
