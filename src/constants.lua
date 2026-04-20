--[[Constants
Contains constants used throughout the game
Window Dimensions
Tile size
Debug Mode Bool
Direction Vectors
User Control Inputs
Map dimensions and render offsets
Tile/Wall IDs, Wall bitmask mapping, and wall collision boxes
]]--
--Window Dimensions
VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--Global DEBUG_MODE to enable all debugging functions
DEBUG_MODE = false

--Directions
DIRECTION_VECTORS = {
    up    = {0, -1},
    down  = {0, 1},
    left  = {-1, 0},
    right = {1, 0},

    ['up_left']    = {-0.7071, -0.7071},
    ['up_right']   = {0.7071, -0.7071},
    ['down_left']  = {-0.7071, 0.7071},
    ['down_right'] = {0.7071, 0.7071}
}


--User inputs
MOVE_LEFT = 'a'
MOVE_RIGHT = 'd'
MOVE_UP = 'w'
MOVE_DOWN = 's'

DODGE = 'space'

INPUT_UP = 'up'
INPUT_DOWN = 'down'
INPUT_LEFT = 'left'
INPUT_RIGHT = 'right'

--Tile Size
TILE_SIZE = 16

--Map Dimensions in tiles
MAP_WIDTH = 100
MAP_HEIGHT = 100
MAP_PLAYABLE_RADIUS = 15

--Tile IDs
TILE_IDS = {

    --Dark Grass floor tiles
    DARK_GRASS_FLOORS = {
        sheet = 'tiles',
        variants = {1, 8, 15}
    },
    DIRT_FILLER = {
        sheet = 'filler',
        variants = {1}
    }
}

--Wall IDs
TILE_IDS.WALL = {
    sheet = 'walls',
    variants = {
        TOP_LEFT_CORNER     = 3,
        TOP_EDGE            = 4,
        TOP_RIGHT_CORNER    = 5,

        LEFT_EDGE           = 8,
        CENTER_FILL         = 9,
        RIGHT_EDGE          = 10,

        BOTTOM_LEFT_CORNER  = 13,
        BOTTOM_EDGE         = 14,
        BOTTOM_RIGHT_CORNER = 15
    }
}

--[[To determine which wall tile to render based on adjacent walls
Using a bitmask system where each direction corresponds to a bit value (up = 0001, down = 0010, left = 0100, right = 1000)]]--
WALL_MASK_MAP = {
    [1+4]   = "TOP_LEFT_CORNER",      -- Up + Left
    [2]     = "TOP_EDGE",             -- Up only
    [1+8]   = "TOP_RIGHT_CORNER",     -- Up + Right

    [4]     = "LEFT_EDGE",            -- Left only
    [8]     = "RIGHT_EDGE",           -- Right only

    [2+4]   = "BOTTOM_LEFT_CORNER",   -- Down + Left
    [1]     = "BOTTOM_EDGE",          -- Down only
    [2+8]   = "BOTTOM_RIGHT_CORNER",  -- Down + Right

    [1+2+4+8] = "CENTER_FILL",
}

--Since some walls are offset, each wall needs an individual collision offset
WALL_COLLISION = {
    [TILE_IDS.WALL.variants.TOP_LEFT_CORNER] = {
        {x = 0, y = 0, width = 8, height = 16 },
        {x = 0, y = 0, width = 16, height = 8}
    },

    [TILE_IDS.WALL.variants.TOP_EDGE] = {
        {x = 0, y = 0, width = 16, height = 4}
    },

    [TILE_IDS.WALL.variants.TOP_RIGHT_CORNER] = {
        {x = 0, y = 0, width = 16, height = 8},
        {x = 8, y = 0, width = 8, height = 16}
    },

    [TILE_IDS.WALL.variants.LEFT_EDGE] = {
        { x = 0, y = 0, width = 8, height = 16 }
    },

    [TILE_IDS.WALL.variants.RIGHT_EDGE] = {
        { x = 8, y = 0, width = 8, height = 16 }
    },

    [TILE_IDS.WALL.variants.BOTTOM_LEFT_CORNER] = {
        { x = 0, y = 8, width = 16, height = 8 }, -- vertical part
        { x = 0, y = 0, width = 8, height = 16 }  -- horizontal part
    },

    [TILE_IDS.WALL.variants.BOTTOM_EDGE] = {
        { x = 0, y = 8, width = 16, height = 8 }
    },

    [TILE_IDS.WALL.variants.BOTTOM_RIGHT_CORNER] = {
        { x = 8, y = 0, width = 8, height = 16 }, -- vertical part
        { x = 0, y = 8, width = 16, height = 8 }  -- horizontal part
    },

    [TILE_IDS.WALL.variants.CENTER_FILL] = {
        { x = 0, y = 0, width = 16, height = 16 }
    }
}
