local generator = require("generator")
local tileWidth = 64
local tileHeight = 32
local mapSize = 2000
local tilemap
local playerSprite
local camera = {
    x = 0,
    y = 0,
    width = 920 * 2,
    height = 1240
}

function love.load()
    tilemap = generator.generateMap(mapSize)
    camera.x = ((mapSize - mapSize) * (tileWidth / 2))
    camera.y = ((mapSize + mapSize) * (tileHeight / 2)) / 2
end

function isoToTile(iso_x, iso_y)
    local col = (iso_x / (tileWidth / 2) + iso_y / (tileHeight / 2)) / 2
    local row = (iso_y / (tileHeight / 2) - iso_x / (tileWidth / 2)) / 2
    return col, row
end

function love.update(dt)
    local speed = 200
    if love.keyboard.isDown("right") then
        camera.x = camera.x + speed * dt
    elseif love.keyboard.isDown("left") then
        camera.x = camera.x - speed * dt
    end

    if love.keyboard.isDown("down") then
        camera.y = camera.y + speed * dt
    elseif love.keyboard.isDown("up") then
        camera.y = camera.y - speed * dt
    end

    if love.keyboard.isDown("escape") then
        love.window.close()
    end
end

local function drawChar()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local squareSize = 40

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill",
        screenWidth / 2 - squareSize / 2,
        screenHeight / 2 - squareSize / 2,
        squareSize,
        squareSize
    )
end

function love.draw()
    local buffer = 2
    
    local corners = {
        {x = camera.x - camera.width / 2, y = camera.y},
        {x = camera.x + camera.width / 2, y = camera.y},
        {x = camera.x - camera.width / 2, y = camera.y + camera.height},
        {x = camera.x + camera.width / 2, y = camera.y + camera.height},
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

            local screen_x = iso_x - camera.x + (camera.width / 2)
            local screen_y = iso_y - camera.y

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
    drawChar()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Camera: "..string.format("%.2f", camera.x)..","..string.format("%.2f", camera.y), 10, 10)
end
