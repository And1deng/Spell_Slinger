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

        on_fire = function(entity)
            local room = entity.room
            if not room then return end

            local ndx, ndy = nil, nil

            -- Try to get nearest target vector
            if entity.get_nearest_target_vector then
                ndx, ndy = entity:get_nearest_target_vector()
            end

            -- Spawn position (center of entity)
            local sx = entity.x + (entity.width or 0) / 2
            local sy = entity.y + (entity.height or 0) / 2

            -- Case 1: Valid target vector
            if ndx ~= nil and ndy ~= nil then
                table.insert(room.projectiles, Projectile({
                    texture = 'fireball',
                    x = sx,
                    y = sy,
                    width = 8,
                    height = 8,
                    dx = ndx,
                    dy = ndy,
                    speed = 200,
                    damage = 1,
                    lifetime = 1
                }))
                return
            end

            -- Case 2: No targets → fire in facing direction
            local dir = entity.direction or 'down'
            local v = DIRECTION_VECTORS[dir]

            -- If direction somehow invalid, cancel firing
            if not v then return end

            table.insert(room.projectiles, Projectile({
                texture = 'fireball',
                x = sx,
                y = sy,
                width = 8,
                height = 8,
                dx = v[1],
                dy = v[2],
                speed = 200,
                damage = 1,
                lifetime = 1
            }))
        end
    }
}
