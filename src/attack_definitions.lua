--[[attack_definitions
Contains spells and enemy attacks with properties and on_cast (player) or onFire (enemy) functions that define the behavior of the attack when executed.
Spells: 3 input patterns, each with unique effects and animations
1. Fireball (up, up, up): Shoots a fireball in the direction, auto aimed
Enemy attack defs:
1. Slime melee: Short range attack in facing direction, hits player if they are within a short distance in that direction when the attack fires
2. Archer shoot: Shoots an arrow towards the player, auto aimed
]]--
ATTACK_DEFS = {
    fireball = {
        input = {'up', 'up', 'up'},
        --Animation here for future enemies to use (maybe a wizard enemy?), only 1 frame since I am using simple sprite
        animation = {
            frames = {1},
            interval = 0.1,
            texture = 'fireball'
        },
        windup = 0.5,
        lifetime = 1.0,
        width = 8,
        height = 8,
        speed = 150,
        damage = 2,

        onCast = function(entity)
            local room = entity.room

            if not room then 
                return 
            end
            
            local attack = ATTACK_DEFS['fireball']
            local nearest_enemy_x, nearest_enemy_y = nil, nil

            if entity.playerGetNearestTargetVector then
                nearest_enemy_x, nearest_enemy_y = entity:playerGetNearestTargetVector()
            end

            --Spawn position (center of entity sprite), hardcoded + 32 because I accidentally used a 64x64 sprite for player
            local projectile_center_x = entity.x - ENTITY_DEFS['player'].offset_x + 32
            local projectile_center_y = entity.y - ENTITY_DEFS['player'].offset_y + 32

            --Case 1: Valid target vector
            if nearest_enemy_x ~= nil and nearest_enemy_y ~= nil then
                table.insert(room.projectiles, Projectile({
                    owner = entity,
                    texture = 'fireball',
                    x = projectile_center_x,
                    y = projectile_center_y,
                    width = attack.width,
                    height = attack.height,
                    vector_x = nearest_enemy_x,
                    vector_y = nearest_enemy_y,
                    speed = attack.speed,
                    damage = attack.damage,
                    lifetime = attack.lifetime
                }))
                return
            else
                --Case 2: If no targets, just fire in facing direction
                local dir = entity.direction
                local player_direction_vector = DIRECTION_VECTORS[dir]

                table.insert(room.projectiles, Projectile({
                    texture = 'fireball',
                    x = projectile_center_x,
                    y = projectile_center_y,
                    width = attack.width,
                    height = attack.height,
                    vector_x = player_direction_vector[1],
                    vector_y = player_direction_vector[2],
                    speed = attack.speed,
                    damage = attack.damage,
                    lifetime = attack.lifetime,
                    owner = entity
                }))
            end
        end
    },
    ice_shard = {
        input = {'right', 'right', 'right'},
        animation = {
            frames = {1},
            interval = 0.1,
            texture = 'ice_shard'
        },
        windup = 0.3,
        lifetime = 0.5,
        width = 8,
        height = 8,
        speed = 300,
        damage = 1,

        onCast = function(entity)
            local room = entity.room

            if not room then 
                return 
            end
            
            local attack = ATTACK_DEFS['ice_shard']
            local nearest_enemy_x, nearest_enemy_y = nil, nil

            if entity.playerGetNearestTargetVector then
                nearest_enemy_x, nearest_enemy_y = entity:playerGetNearestTargetVector()
            end

            local projectile_center_x = entity.x - ENTITY_DEFS['player'].offset_x + 32
            local projectile_center_y = entity.y - ENTITY_DEFS['player'].offset_y + 32

            if nearest_enemy_x ~= nil and nearest_enemy_y ~= nil then
                table.insert(room.projectiles, Projectile({
                    owner = entity,
                    texture = 'ice_shard',
                    x = projectile_center_x,
                    y = projectile_center_y,
                    width = attack.width,
                    height = attack.height,
                    vector_x = nearest_enemy_x,
                    vector_y = nearest_enemy_y,
                    speed = attack.speed,
                    damage = attack.damage,
                    lifetime = attack.lifetime
                }))
                return
            else
                local dir = entity.direction
                local player_direction_vector = DIRECTION_VECTORS[dir]


                table.insert(room.projectiles, Projectile({
                    texture = 'ice_shard',
                    x = projectile_center_x,
                    y = projectile_center_y,
                    width = attack.width,
                    height = attack.height,
                    vector_x = player_direction_vector[1],
                    vector_y = player_direction_vector[2],
                    speed = attack.speed,
                    damage = attack.damage,
                    lifetime = attack.lifetime,
                    owner = entity
                }))
            end
        end
    },
    boulder = {
        input = {'down', 'down', 'down'},

        animation = {
            frames = {1},
            interval = 0.1,
            texture = 'boulder'
        },
        windup = 1,
        lifetime = 3.0,
        width = 16,
        height = 16,
        speed = 50,
        damage = 5,

        onCast = function(entity)
            local room = entity.room

            if not room then 
                return 
            end
            
            local attack = ATTACK_DEFS['boulder']
            local nearest_enemy_x, nearest_enemy_y = nil, nil

            if entity.playerGetNearestTargetVector then
                nearest_enemy_x, nearest_enemy_y = entity:playerGetNearestTargetVector()
            end

            local projectile_center_x = entity.x - ENTITY_DEFS['player'].offset_x + 32
            local projectile_center_y = entity.y - ENTITY_DEFS['player'].offset_y + 32

            if nearest_enemy_x ~= nil and nearest_enemy_y ~= nil then
                table.insert(room.projectiles, Projectile({
                    owner = entity,
                    texture = 'boulder',
                    x = projectile_center_x,
                    y = projectile_center_y,
                    width = attack.width,
                    height = attack.height,
                    vector_x = nearest_enemy_x,
                    vector_y = nearest_enemy_y,
                    speed = attack.speed,
                    damage = attack.damage,
                    lifetime = attack.lifetime
                }))
                return
            else
                local dir = entity.direction
                local player_direction_vector = DIRECTION_VECTORS[dir]


                table.insert(room.projectiles, Projectile({
                    texture = 'boulder',
                    x = projectile_center_x,
                    y = projectile_center_y,
                    width = attack.width,
                    height = attack.height,
                    vector_x = player_direction_vector[1],
                    vector_y = player_direction_vector[2],
                    speed = attack.speed,
                    damage = attack.damage,
                    lifetime = attack.lifetime,
                    owner = entity
                }))
            end
        end
    }
}

ENEMY_ATTACK_DEFS = {
    slime_melee = {
        windup = 0.18,
        lifetime = 0.45,

        onFire = function(entity)
            local room = entity.room

            if not room or not room.player or room.player.dead then
                return
            end

            local hitbox_x, hitbox_y
            local hitbox_w, hitbox_h
            --Temp value
            local reach = 16

            if entity.direction == 'left' then
                hitbox_x = entity.x - reach
                hitbox_y = entity.y
                hitbox_w = reach
                hitbox_h = entity.height
            elseif entity.direction == 'right' then
                hitbox_x = entity.x + entity.width
                hitbox_y = entity.y
                hitbox_w = reach
                hitbox_h = entity.height
            elseif entity.direction == 'up' then
                hitbox_x = entity.x
                hitbox_y = entity.y - reach
                hitbox_w = entity.width
                hitbox_h = reach
            elseif entity.direction == 'down' then
                hitbox_x = entity.x
                hitbox_y = entity.y + entity.height
                hitbox_w = entity.width
                hitbox_h = reach
            else
                return
            end

            local player = room.player

            local overlaps =
                hitbox_x < player.x + player.width and
                hitbox_x + hitbox_w > player.x and
                hitbox_y < player.y + player.height and
                hitbox_y + hitbox_h > player.y

            if overlaps and not player.invulnerable then
                player:dealDamage(entity.damage or 1)

                if player.dead then
                    room.frozen = true
                end

                player:goInvulnerable()
            end
        end
    },
    archer_shoot = {
        windup = 1,
        lifetime = 2,
        width = 8,
        height = 8,
        speed = 100,
        damage = 3,

        onFire = function(entity)
            local attack = ENEMY_ATTACK_DEFS['archer_shoot']
            local room = entity.room
            if not room or not room.player or room.player.dead then
                return
            end

            if DEBUG_MODE then
                DebugLog.log("[archer_shoot] onFire called for %s", tostring(entity))
            end

            local target_vector_x, target_vector_y = nil, nil

            if entity.enemyGetNearestTargetVector then
                target_vector_x, target_vector_y = entity:enemyGetNearestTargetVector()
            end

            local projectile_center_x = entity.x + entity.width / 2
            local projectile_center_y = entity.y + entity.height / 2

            if target_vector_x == nil or target_vector_y == nil then
                return
            end

            table.insert(room.projectiles, Projectile({
                owner = entity,
                texture = 'arrow',
                x = projectile_center_x,
                y = projectile_center_y,
                width = 8,
                height = 8,
                vector_x = target_vector_x,
                vector_y = target_vector_y,
                speed = attack.speed,
                damage = attack.damage,
                lifetime = attack.lifetime,
            }))
         end
    }
}
