--[[
    Perlin Noise implementation for LÖVE
    Compatible with Lua 5.1 (no bit32 library)
]]--

perlin = {}
perlin.p = {}

-- Hash lookup table as defined by Ken Perlin
local permutation = {151,160,137,91,90,15,
  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
  190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
  88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
  102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
  135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
  223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
  129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
  251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
  49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
}

-- p is used to hash unit cube coordinates to [0, 255]
for i=0,255 do
    perlin.p[i] = permutation[i+1]
    perlin.p[i+256] = permutation[i+1]
end

-- Bitwise AND replacement for Lua 5.1
local function band(a, b)
    local result = 0
    local bit = 1
    while a > 0 or b > 0 do
        if a % 2 == 1 and b % 2 == 1 then
            result = result + bit
        end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bit = bit * 2
    end
    return result
end

-- Alternative: Use modulo for simple cases (since we're doing & 255)
local function band255(x)
    return x % 256  -- Equivalent to x & 255
end

-- Return range: [-1, 1]
function perlin:noise(x, y, z)
    y = y or 0
    z = z or 0

    -- Calculate the "unit cube" that the point asked will be located in
    -- Using modulo 256 instead of bitwise AND
    local xi = math.floor(x) % 256
    local yi = math.floor(y) % 256
    local zi = math.floor(z) % 256

    -- Next we calculate the location (from 0 to 1) in that cube
    x = x - math.floor(x)
    y = y - math.floor(y)
    z = z - math.floor(z)

    -- We also fade the location to smooth the result
    local u = self.fade(x)
    local v = self.fade(y)
    local w = self.fade(z)

    -- Hash all 8 unit cube coordinates surrounding input coordinate
    local p = self.p
    local A, AA, AB, AAA, ABA, AAB, ABB, B, BA, BB, BAA, BBA, BAB, BBB
    
    A   = p[xi] + yi
    AA  = p[A] + zi
    AB  = p[A + 1] + zi
    AAA = p[AA]
    ABA = p[AB]
    AAB = p[AA + 1]
    ABB = p[AB + 1]

    B   = p[xi + 1] + yi
    BA  = p[B] + zi
    BB  = p[B + 1] + zi
    BAA = p[BA]
    BBA = p[BB]
    BAB = p[BA + 1]
    BBB = p[BB + 1]

    -- Take the weighted average between all 8 unit cube coordinates
    return self.lerp(w,
        self.lerp(v,
            self.lerp(u,
                self:grad(AAA, x, y, z),
                self:grad(BAA, x - 1, y, z)
            ),
            self.lerp(u,
                self:grad(ABA, x, y - 1, z),
                self:grad(BBA, x - 1, y - 1, z)
            )
        ),
        self.lerp(v,
            self.lerp(u,
                self:grad(AAB, x, y, z - 1),
                self:grad(BAB, x - 1, y, z - 1)
            ),
            self.lerp(u,
                self:grad(ABB, x, y - 1, z - 1),
                self:grad(BBB, x - 1, y - 1, z - 1)
            )
        )
    )
end

-- Gradient function finds dot product between pseudorandom gradient vector
-- and the vector from input coordinate to a unit cube vertex
perlin.dot_product = {
    [0] = function(x, y, z) return  x + y end,
    [1] = function(x, y, z) return -x + y end,
    [2] = function(x, y, z) return  x - y end,
    [3] = function(x, y, z) return -x - y end,
    [4] = function(x, y, z) return  x + z end,
    [5] = function(x, y, z) return -x + z end,
    [6] = function(x, y, z) return  x - z end,
    [7] = function(x, y, z) return -x - z end,
    [8] = function(x, y, z) return  y + z end,
    [9] = function(x, y, z) return -y + z end,
    [10] = function(x, y, z) return  y - z end,
    [11] = function(x, y, z) return -y - z end,
    [12] = function(x, y, z) return  y + x end,
    [13] = function(x, y, z) return -y + z end,
    [14] = function(x, y, z) return  y - x end,
    [15] = function(x, y, z) return -y - z end
}

function perlin:grad(hash, x, y, z)
    -- Use modulo 16 instead of bitwise AND 0xF
    local h = hash % 16
    return self.dot_product[h](x, y, z)
end

-- Fade function is used to smooth final output
function perlin.fade(t)
    return t * t * t * (t * (t * 6 - 15) + 10)
end

function perlin.lerp(t, a, b)
    return a + t * (b - a)
end

-- Helper function for fractal noise (multi-octave Perlin)
function perlin:fractal(x, y, octaves, persistence, scale)
    octaves = octaves or 4
    persistence = persistence or 0.5
    scale = scale or 0.01
    
    local total = 0
    local frequency = 1
    local amplitude = 1
    local maxValue = 0
    
    for i = 1, octaves do
        total = total + self:noise(x * scale * frequency, y * scale * frequency) * amplitude
        maxValue = maxValue + amplitude
        amplitude = amplitude * persistence
        frequency = frequency * 2
    end
    
    return total / maxValue
end

return perlin