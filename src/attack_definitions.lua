ATTACK_DEFS = {
    fireball = {
        input = {'up', 'up', 'up'},
        animation = {
            frames = {1,2,3,4,5,6},
            interval = 0.1,
            texture = 'fireball'
        },
        windup = 0.3,
        totalDuration = 1.0,
        onFire = function(entity)
            local room = entity.room
            local projectile = Projectile({
                texture = 'fireball',
                x = entity.x + entity.width / 2,
                y = entity.y + entity.height / 2,
                speed = 200,
                direction = entity.direction,
                damage = 10,
                lifetime = 1
            })

            table.insert(room.projectiles, projectile)
        end
    }
}
