local tileWidth = 32
local tileHeight = 32
local speed = 10 --vitesse de déplacement


local Camera = {
    scale = 1.0,
    initialized = false,
    spriteTile = {},
    x = 0,
    y = 0,
    width = 920 * 2,
    height = 1240,
    moveX = 0,
    moveY = 0,
    stepX = speed,
    stepY = speed,
    tilemap = {}
}
local function isoToTile(iso_x, iso_y)
    local col = (iso_x / (tileWidth / 2) + iso_y / (tileHeight / 2)) / 2
    local row = (iso_y / (tileHeight / 2) - iso_x / (tileWidth / 2)) / 2
    return col, row
end

function Camera.SetDepartPoint()
    -- Calculer la taille de la carte
    local minRow, maxRow = math.huge, -math.huge
    local minCol, maxCol = math.huge, -math.huge
    for row, cols in pairs(Camera.tilemap) do
        minRow = math.min(minRow, row)
        maxRow = math.max(maxRow, row)
        for col in pairs(cols) do
            minCol = math.min(minCol, col)
            maxCol = math.max(maxCol, col)
        end
    end

    local mapWidth = maxCol - minCol + 1
    local mapHeight = maxRow - minRow + 1

    local centerTileX = minCol + (mapWidth - 1) / 2
    local centerTileY = minRow + (mapHeight - 1) / 2

    local centerX = (centerTileX - centerTileY) * (tileWidth / 2)
    local centerY = (centerTileX + centerTileY) * (tileHeight / 4)
    Camera.x = centerX
    Camera.y = centerY
    Camera.initialized = true
end

function PointInMenu(mouseX, mouseY)
    local menux, menuy = 10, 10
    local menuWidth, menuHeight = 80, 350
    return mouseX >= menux and mouseX <= menux + menuWidth and
        mouseY >= menuy and mouseY <= menuy + menuHeight
end

--
function pointInIsoTile(points, px, py)
    local inside = false
    local n = #points / 2
    local j = n

    for i = 1, n do
        local xi, yi = points[2 * i - 1], points[2 * i]
        local xj, yj = points[2 * j - 1], points[2 * j]

        if ((yi > py) ~= (yj > py)) and
            (px < (xj - xi) * (py - yi) / (yj - yi) + xi) then
            inside = not inside
        end
        j = i
    end

    return inside
end

function Camera.Draw()
    if not Camera.initialized then
        Camera.SetDepartPoint()
    end

    local scale = Camera.scale or 1.0
    local buffer = 2
    local halfW, halfH = Camera.width / 2, Camera.height / 2

    -- définir les coins de la vue
    local corners = {
        { x = Camera.x - halfW / scale, y = Camera.y },
        { x = Camera.x + halfW / scale, y = Camera.y },
        { x = Camera.x - halfW / scale, y = Camera.y + Camera.height / scale },
        { x = Camera.x + halfW / scale, y = Camera.y + Camera.height / scale },
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
    local mouseX, mouseY = love.mouse.getPosition()

    for row = start_row, end_row do
        for col = start_col, end_col do
            local tile = Camera.tilemap[row] and Camera.tilemap[row][col]

            local iso_x = (col - row) * (tileWidth / 2)
            local iso_y = (col + row) * (tileHeight / 4)

            local screen_x = (iso_x - Camera.x) * scale + halfW
            local screen_y = (iso_y - Camera.y) * scale + halfH

            local sw = tileWidth * scale
            local sh = tileHeight * scale

            local points = {
                screen_x, screen_y + sh / 2,
                screen_x + sw / 2, screen_y,
                screen_x + sw, screen_y + sh / 2,
                screen_x + sw / 2, screen_y + sh
            }
            if tile == 0 then
                local sprite = Camera.spriteTile.dirt
                if sprite then
                    local spriteWidth = sprite:getWidth()               -- 32
                    local spriteHeight = sprite:getHeight()             -- 32

                    local scale_x = (tileWidth / spriteWidth) * scale   -- 64 / 32 = 2
                    local scale_y = (tileHeight / spriteHeight) * scale -- 32 / 32 = 1

                    love.graphics.draw(
                        sprite,
                        screen_x,
                        screen_y,
                        0, scale_x, scale_y,
                        spriteWidth / 2, spriteHeight / 2
                    )
                end
            elseif tile == 1 then
                local sprite = Camera.spriteTile.grass
                if sprite then
                    local spriteWidth = sprite:getWidth()               -- 32
                    local spriteHeight = sprite:getHeight()             -- 32

                    local scale_x = (tileWidth / spriteWidth) * scale   -- 64 / 32 = 2
                    local scale_y = (tileHeight / spriteHeight) * scale -- 32 / 32 = 1

                    love.graphics.draw(
                        sprite,
                        screen_x,
                        screen_y,
                        0, scale_x, scale_y,
                        spriteWidth / 2, spriteHeight / 2
                    )
                end
            end
            if pointInIsoTile(points, mouseX, mouseY) and not PointInMenu(mouseX, mouseY) then
                love.graphics.setColor(0, 1, 0)
            end
        end
    end
end

function Camera.Load(tilemap)
    Camera.spriteTile.dirt = love.graphics.newImage("Assets/sprites/dirt.png")
    Camera.spriteTile.grass = love.graphics.newImage("Assets/sprites/grass.png")
    Camera.tilemap = tilemap
end

function Camera.PreUpdate()
    Camera.moveX, Camera.moveY = 0, 0
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

function Camera.moveNorthWest()
    Camera.moveX = Camera.moveX - Camera.stepX / 2
    Camera.moveY = Camera.moveY - Camera.stepY / 2
end

function Camera.moveSouth()
    Camera.moveY = Camera.moveY + Camera.stepY / 2
end

function Camera.moveEast()
    Camera.moveX = Camera.moveX + Camera.stepX / 2
end

function Camera.moveSouthEast()
    Camera.moveX = Camera.moveX + Camera.stepX / 2
    Camera.moveY = Camera.moveY + Camera.stepY / 2
end

function Camera.moveWest()
    Camera.moveX = Camera.moveX - Camera.stepX / 2
end

return Camera
