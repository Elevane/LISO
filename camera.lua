

local ms = 200
local tileWidth = 64
local tileHeight = 32
local speed = 3 --vitesse de déplacement
local generator = require("generator")
local tilemap = generator.generateMap(ms)

local Camera = {
    mapSize = ms,
    x = ((ms - ms) * (tileWidth / 2)),
    y = ((ms + ms) * (tileHeight / 2)) / 2,
    width = 920 * 2,
    height = 1240,
    moveX= 0,
    moveY = 0,
    stepX = speed,
    stepY= speed
}

local function isoToTile(iso_x, iso_y)
    local col = (iso_x / (tileWidth / 2) + iso_y / (tileHeight / 2)) / 2
    local row = (iso_y / (tileHeight / 2) - iso_x / (tileWidth / 2)) / 2
    return col, row
end

function  Camera.Draw()
    local buffer = 2
    local corners = {
        {x = Camera.x - Camera.width / 2, y = Camera.y},
        {x = Camera.x + Camera.width / 2, y = Camera.y},
        {x = Camera.x - Camera.width / 2, y = Camera.y + Camera.height},
        {x = Camera.x + Camera.width / 2, y = Camera.y + Camera.height},
    }
    local min_col, max_col = math.huge, -math.huge
    local min_row, max_row = math.huge, -math.huge
    for _, corner in ipairs(corners) do
        local col, row = isoToTile(corner.x, corner.y)
        min_col = math.min(min_col, col)
        max_col = math.max(max_col, col)
        min_row = math.min(min_row, row)
        max_row = math.max(max_row, row)
    end
    local start_col = math.floor(min_col) - buffer
    local end_col = math.ceil(max_col) + buffer
    local start_row = math.floor(min_row) - buffer
    local end_row = math.ceil(max_row) + buffer
    for row = start_row, end_row do
        for col = start_col, end_col do
            local tile = tilemap[row] and tilemap[row][col]
            if tile == 1 then
                love.graphics.setColor(1, 1, 1)
            else
                love.graphics.setColor(0, 0, 0)
            end
            local iso_x = (col - row) * (tileWidth / 2)
            local iso_y = (col + row) * (tileHeight / 2)
            local screen_x = iso_x - Camera.x + (Camera.width / 2)
            local screen_y = iso_y - Camera.y
            local points = {
                screen_x, screen_y + tileHeight / 2,
                screen_x + tileWidth / 2, screen_y,
                screen_x + tileWidth, screen_y + tileHeight / 2,
                screen_x + tileWidth / 2, screen_y + tileHeight
            }
            love.graphics.polygon("fill", points)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(1)
            love.graphics.polygon("line", points)
        end
    end
end
function Camera.PreUpdate()
    Camera.moveX, Camera.moveY = Camera.moveX-0.3, Camera.moveY-0.3 -- deceleration
end

function Camera.Update()
    Camera.x = Camera.x + Camera.moveX
    Camera.y = Camera.y + Camera.moveY
end

function Camera.moveNorth()
    Camera.moveY = Camera.moveY - Camera.stepY / 2
    
end

function Camera.moveNorthEast()
    Camera.moveX = Camera.moveX + Camera.stepX / 2
    Camera.moveY = Camera.moveY - Camera.stepY / 2
    
end

function Camera.moveSouthWest()
    Camera.moveX = Camera.moveX - Camera.stepX / 2
    Camera.moveY = Camera.moveY + Camera.stepY / 2
    
end

function  Camera.moveNorthWest()
    Camera.moveX =  Camera.moveX -  Camera.stepX / 2
    Camera.moveY = Camera.moveY - Camera.stepY / 2
    
end
function Camera.moveSouth()
    Camera.moveY = Camera.moveY + Camera.stepY / 2
    
end

function Camera.moveEast()
    Camera.moveX = Camera.moveX + Camera.stepX / 2
    
end

function Camera.moveSouthEast()
    Camera.moveX =  Camera.moveX +  Camera.stepX / 2
    Camera.moveY = Camera.moveY +  Camera.stepY / 2
    
end

function Camera.moveWest()
    Camera.moveX = Camera.moveX - Camera.stepX / 2
end


return Camera