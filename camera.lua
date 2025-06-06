local tileWidth = 64
local tileHeight = 32
local speed = 5 --vitesse de déplacement


local Camera = {
    initialized = false,
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
    local centerY = (centerTileX + centerTileY) * (tileHeight / 2)
    Camera.x = centerX + 520
    Camera.y = centerY - 240
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
    local buffer = 2
    --define viewport
    local corners = {
        { x = Camera.x - Camera.width / 2, y = Camera.y },
        { x = Camera.x + Camera.width / 2, y = Camera.y },
        { x = Camera.x - Camera.width / 2, y = Camera.y + Camera.height },
        { x = Camera.x + Camera.width / 2, y = Camera.y + Camera.height },
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
    --define viewport in tilemap
    local start_col = math.floor(min_col) - buffer
    local end_col = math.ceil(max_col) + buffer
    local start_row = math.floor(min_row) - buffer
    local end_row = math.ceil(max_row) + buffer
    local mouseX, mouseY = love.mouse.getPosition()

    --draw tiles
    for row = start_row, end_row do
        for col = start_col, end_col do
            local tile = Camera.tilemap[row] and Camera.tilemap[row][col]


            local iso_x = (col - row) * (tileWidth / 2)
            local iso_y = (col + row) * (tileHeight / 2)
            local screen_x = iso_x - Camera.x + (Camera.width / 2)
            local screen_y = iso_y - Camera.y
            local points = {
                screen_x,
                screen_y + tileHeight / 2,
                screen_x + tileWidth / 2, screen_y,
                screen_x + tileWidth,
                screen_y + tileHeight / 2,
                screen_x + tileWidth / 2,
                screen_y + tileHeight
            }

            if tile == 1 then
                love.graphics.setColor(1, 1, 1)
            elseif tile == 0 then
                love.graphics.setColor(1, 0, 0)
            else
                love.graphics.setColor(0, 0, 0)
            end
            if
                pointInIsoTile(points, mouseX, mouseY) and not PointInMenu(mouseX, mouseY)
            then
                love.graphics.setColor(0, 1, 0)
            end
            love.graphics.polygon("fill", points)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(1)
            love.graphics.polygon("line", points)
        end
    end
end

function Camera.Load(tilemap)
    Camera.tilemap = tilemap
end

function Camera.PreUpdate()
    Camera.moveX, Camera.moveY = 0, 0 -- deceleration
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
