--[[Spell and attack definitions
Spells: 3 input patterns, each with unique effects and animations
1. Fireball (up, up, up): Shoots a fireball in the direction, auto aimed
Enemy attack defs: None yet
]]--
ATTACK_DEFS = {
    fireball = {
        input = {'up', 'up', 'up'},
        animation = {
            frames = {1,2,3,4,5,6},
            interval = 0.1,
            texture = 'fireball'
        },
        windup = 0.3,
        total_duration = 1.0,

        on_cast = function(entity)
            local room = entity.room
            if not room then return end

            local nearest_enemy_dx, nearest_enemy_dy = nil, nil

            -- Try to get nearest target vector
            if entity.get_nearest_target_vector then
                nearest_enemy_dx, nearest_enemy_dy = entity:get_nearest_target_vector()
            end

            -- Spawn position (center of entity)
            local projectile_center_x = entity.x + (entity.width or 0) / 2
            local projectile_center_y = entity.y + (entity.height or 0) / 2

            -- Case 1: Valid target vector
            if nearest_enemy_dx ~= nil and nearest_enemy_dy ~= nil then
                table.insert(room.projectiles, Projectile({
                    texture = 'fireball',
                    x = projectile_center_x,
                    y = projectile_center_y,
                    width = 8,
                    height = 8,
                    dx = nearest_enemy_dx,
                    dy = nearest_enemy_dy,
                    speed = 200,
                    damage = 5,
                    lifetime = 1
                }))
                return
            else
                -- Case 2: No targets → fire in facing direction
                local dir = entity.direction or 'right'
                local player_direction_vector = DIRECTION_VECTORS[dir]

                -- If direction somehow invalid, cancel firing
                if not player_direction_vector then return end

                table.insert(room.projectiles, Projectile({
                    texture = 'fireball',
                    x = projectile_center_x,
                    y = projectile_center_y,
                    width = 8,
                    height = 8,
                    dx = player_direction_vector[1],
                    dy = player_direction_vector[2],
                    speed = 200,
                    damage = 1,
                    lifetime = 1
                }))
            end
        end
    }
}
