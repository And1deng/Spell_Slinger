--[[Entity Definitions
Contains player and enemy definitions, including animations and stats. Can be expanded with more entities and properties as needed.
]]--
ENTITY_DEFS = {
    ['player'] = {
        max_health = 10,
        walk_speed = 100,
        offset_x = 24,
        offset_y = 26,
        dodge_distance = 50,
        dodge_speed = 200,
        invulnerable_length = 1,
        animations = {
            ['walk_left'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character_walk_left'
            },
            ['walk_right'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character_walk_right'
            },
            ['walk_up'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character_walk_up'
            },
            ['walk_down'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character_walk_down'
            },
            ['idle_left'] = {
                frames = {1},
                texture = 'character_walk_left'
            },
            ['idle_right'] = {
                frames = {1},
                texture = 'character_walk_right'
            },
            ['idle_up'] = {
                frames = {1},
                texture = 'character_walk_up'
            },
            ['idle_down'] = {
                frames = {1},
                texture = 'character_walk_down'
            },
            ['death'] = {
                frames = {1,2,3,4,5,6,7,8},
                interval = 0.2,
                texture = 'character_death',
                looping = false
            }
        }
    },
    ['dummy'] = {
        max_health = 10,
        damage = 1,
        walk_speed = 0,
        animations = {
            ['walk_left'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character_walk_left'
            },
            ['walk_right'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character_walk_right'
            },
            ['walk_up'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character_walk_up'
            },
            ['walk_down'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character_walk_down'
            },
            ['idle_left'] = {
                frames = {1},
                texture = 'character_walk_left'
            },
            ['idle_right'] = {
                frames = {1},
                texture = 'character_walk_right'
            },
            ['idle_up'] = {
                frames = {1},
                texture = 'character_walk_up'
            },
            ['idle_down'] = {
                frames = {1},
                texture = 'character_walk_down'
            }
        }
    },
    ['slime'] = {
        max_health = 3,
        damage = 1,
        walk_speed = 30,
        chase_range = 100,
        attack_range = 24,
        attack_name = 'slime_melee',
        points = 100,
        animations = {
            ['walk_left'] = {
                frames = {6,7,8,9},
                interval = 0.2,
                texture = 'slime',
                flip = true
            },
            ['walk_right'] = {
                frames = {6,7,8,9},
                interval = 0.2,
                texture = 'slime'
            },
            ['walk_up'] = {
                frames = {11,12,13,14},
                interval = 0.2,
                texture = 'slime'
            },
            ['walk_down'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'slime'
            },
            ['idle_left'] = {
                frames = {6},
                texture = 'slime',
                flip = true
            },
            ['idle_right'] = {
                frames = {6},
                texture = 'slime'
            },
            ['idle_up'] = {
                frames = {11},
                texture = 'slime'
            },
            ['idle_down'] = {
                frames = {1},
                texture = 'slime'
            },
            ['attack_left'] = {
                frames = {9,10,9},
                interval = 0.2,
                texture = 'slime',
                flip = true
            },
            ['attack_right'] = {
                frames = {9,10,9},
                interval = 0.2,
                texture = 'slime'
            },
            ['attack_up'] = {
                frames = {14,15,14},
                interval = 0.2,
                texture = 'slime'
            },
            ['attack_down'] = {
                frames = {4,5,4},
                interval = 0.2,
                texture = 'slime'
            },
            ['death'] = {
                frames = {16,17,18,19},
                interval = 0.2,
                texture = 'slime',
                looping = false
            }
        },
        ai_profile = 'aggro'
    },
        --archer free sprite sheet only contains idle animations unfortunately
        ['archer'] = {
        max_health = 1,
        damage = 2,
        walk_speed = 20,
        ranged = true,
        chase_range = 200,
        attack_range = 150,
        attack_name = 'archer_shoot',
        points = 100,
        animations = {
            ['walk_left'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer',
                flip = true
            },
            ['walk_right'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer'
            },
            ['walk_up'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer'
            },
            ['walk_down'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer'
            },
            ['idle_left'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer',
                flip = true
            },
            ['idle_right'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer'
            },
            ['idle_up'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer'
            },
            ['idle_down'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer'
            },
            ['attack_left'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer',
                flip = true
            },
            ['attack_right'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer'
            },
            ['attack_up'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer'
            },
            ['attack_down'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer'
            },
            ['death'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'archer',
                looping = false
            }
        },
        ai_profile = 'aggro'
    },
    --Mummy free sprite sheet only contains idle animations unfortunately
    ['mummy'] = {
        max_health = 10,
        damage = 2,
        walk_speed = 10,
        ranged = false,
        chase_range = 100,
        attack_range = 24,
        attack_name = 'mummy_melee',
        points = 200,
        animations = {
            ['walk_left'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy',
                flip = true
            },
            ['walk_right'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy'
            },
            ['walk_up'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy'
            },
            ['walk_down'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy'
            },
            ['idle_left'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy',
                flip = true
            },
            ['idle_right'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy'
            },
            ['idle_up'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy'
            },
            ['idle_down'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy'
            },
            ['attack_left'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy',
                flip = true
            },
            ['attack_right'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy'
            },
            ['attack_up'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy'
            },
            ['attack_down'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy'
            },
            ['death'] = {
                frames = {1,2,3,4},
                interval = 0.2,
                texture = 'mummy',
                looping = false
            }
        },
        ai_profile = 'aggro'
    }
} 

