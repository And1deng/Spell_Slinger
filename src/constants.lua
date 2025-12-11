--Constants used throughout the game
--Window Dimensions--
VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--user inputs--
MOVE_LEFT = 'a'
MOVE_RIGHT = 'd'
MOVE_UP = 'w'
MOVE_DOWN = 's'

DODGE = 'space'

INPUT_UP = 'up'
INPUT_DOWN = 'down'
INPUT_LEFT = 'left'
INPUT_RIGHT = 'right'



--Tile Size--
TILE_SIZE = 16

--Map Dimensions--
MAP_WIDTH = 100
MAP_HEIGHT = 100

MAP_RENDER_OFFSET_X = (VIRTUAL_WIDTH - (MAP_WIDTH * TILE_SIZE)) / 2
MAP_RENDER_OFFSET_Y = (VIRTUAL_HEIGHT - (MAP_HEIGHT * TILE_SIZE)) / 2

--Tile IDs--
TILE_IDS = {

    -- Dark Grass floor tiles
    DARK_GRASS_FLOORS = {
        sheet = 'tiles',
        variants = {1, 8, 15}
    },
    DIRT_FILLER = {
        sheet = 'filler',
        variants = {1}
    },

    -- Wall corner tiles
    DIRT_WALL_TOP_LEFT_CORNER = {
        sheet = 'walls',
        variants = {3}
    },

    DIRT_WALL_TOP_RIGHT_CORNER = {
        sheet = 'walls',
        variants = {5}
    },

    DIRT_WALL_BOTTOM_LEFT_CORNER = {
        sheet = 'walls',
        variants = {13}
    },

    DIRT_WALL_BOTTOM_RIGHT_CORNER = {
        sheet = 'walls',
        variants = {15}
    },

    -- Wall straight sections
    DIRT_WALL_TOP_WALLS = {
        sheet = 'walls',
        variants = {4}
    },

    DIRT_WALL_BOTTOM_WALLS = {
        sheet = 'walls',
        variants = {14}
    },

    DIRT_WALL_LEFT_WALLS = {
        sheet = 'walls',
        variants = {8}
    },

    DIRT_WALL_RIGHT_WALLS = {
        sheet = 'walls',
        variants = {10}
    }
}

TILE_IDS.WALL = {
    sheet = 'walls',
    variants = {
        TOP_LEFT_CORNER     = 15,
        TOP_EDGE            = 14,
        TOP_RIGHT_CORNER    = 13,

        LEFT_EDGE           = 8,
        CENTER_FILL         = 9,
        RIGHT_EDGE          = 10,

        BOTTOM_LEFT_CORNER  = 5,
        BOTTOM_EDGE         = 4,
        BOTTOM_RIGHT_CORNER = 3
    }
}

WALL_MASK_MAP = {
    [1+4]   = "TOP_LEFT_CORNER",      -- Up + Left
    [1]     = "TOP_EDGE",             -- Up only
    [1+8]   = "TOP_RIGHT_CORNER",     -- Up + Right

    [4]     = "LEFT_EDGE",            -- Left only
    [8]     = "RIGHT_EDGE",           -- Right only

    [2+4]   = "BOTTOM_LEFT_CORNER",   -- Down + Left
    [2]     = "BOTTOM_EDGE",          -- Down only
    [2+8]   = "BOTTOM_RIGHT_CORNER",  -- Down + Right

    -- Surrounded on all 4 sides → inner fill
    [1+2+4+8] = "CENTER_FILL",
}
