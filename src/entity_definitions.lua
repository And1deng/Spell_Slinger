--Enemy AI, can add more profiles for different enemy behaviors
AI_PROFILES = {
    basic = {
        chaseRange = 120,
        attackRange = 40,
        fleeHealth = 0
    }
}

--Player and enemy definitions, including animations and stats. Can be expanded with more entities and properties as needed.
ENTITY_DEFS = {
    ['player'] = {
        max_health = 2,
        walk_speed = 100,
        animations = {
            ['walk-left'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character-walk-left'
            },
            ['walk-right'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character-walk-right'
            },
            ['walk-up'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character-walk-up'
            },
            ['walk-down'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character-walk-down'
            },
            ['idle-left'] = {
                frames = {1},
                texture = 'character-walk-left'
            },
            ['idle-right'] = {
                frames = {1},
                texture = 'character-walk-right'
            },
            ['idle-up'] = {
                frames = {1},
                texture = 'character-walk-up'
            },
            ['idle-down'] = {
                frames = {1},
                texture = 'character-walk-down'
            },
            ['death'] = {
                frames = {1,2,3,4,5,6,7,8},
                interval = 0.2,
                texture = 'character-death',
                looping = false
            }
        }
    },
    ['dummy'] = {
        max_health = 10,
        damage = 1,
        walk_speed = 0,
        animations = {
            ['walk-left'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character-walk-left'
            },
            ['walk-right'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character-walk-right'
            },
            ['walk-up'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character-walk-up'
            },
            ['walk-down'] = {
                frames = {1,2,3,4,5,6},
                interval = 0.2,
                texture = 'character-walk-down'
            },
            ['idle-left'] = {
                frames = {1},
                texture = 'character-walk-left'
            },
            ['idle-right'] = {
                frames = {1},
                texture = 'character-walk-right'
            },
            ['idle-up'] = {
                frames = {1},
                texture = 'character-walk-up'
            },
            ['idle-down'] = {
                frames = {1},
                texture = 'character-walk-down'
            }
        }
    },
    ['slime'] = {
        max_health = 10,
        damage = 1,
        walk_speed = 20,
        animations = {
            ['walk-left'] = {
                frames = {1,2,3,4,5},
                interval = 0.2,
                texture = 'slime',
                flip = true
            },
            ['walk-right'] = {
                frames = {6,7,8,9,10},
                interval = 0.2,
                texture = 'slime'
            },
            ['walk-up'] = {
                frames = {11,12,13,14,15},
                interval = 0.2,
                texture = 'slime'
            },
            ['walk-down'] = {
                frames = {1,2,3,4,5},
                interval = 0.2,
                texture = 'slime'
            },
            ['idle-left'] = {
                frames = {1},
                texture = 'slime'
            },
            ['idle-right'] = {
                frames = {1},
                texture = 'slime'
            },
            ['idle-up'] = {
                frames = {1},
                texture = 'slime'
            },
            ['idle-down'] = {
                frames = {1},
                texture = 'slime'
            },
            ['death'] = {
                frames = {16,17,18,19},
                interval = 0.2,
                texture = 'character-death',
                looping = false
            }
        },
        ai_profile = { type = 'aggro', range = AI_PROFILES.basic.chaseRange }
    }
} 

