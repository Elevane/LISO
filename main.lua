
local generator = require("generator")
local tileWidth = 64
local tileHeight = 32
local mapSize = 2000
local tilemap
local currentDirection = "south"

local camera = {
    x = 0,
    y = 0,
    width = 920 * 2,
    height = 1240
}
local spriteSheet
local quads = {}
local currentFrame = 1
local timer = 0
local moved = false

local idles = {
    north = {
        filepath = "Assets/Character/Idle/Knight_Idle_dir4.png",
        animationData = require("Assets.Character.Idle.Knight_Idle_dir4")
    },
    northEast = {
        filepath = "Assets/Character/Idle/Knight_Idle_dir5.png",
        animationData = require("Assets.Character.Idle.Knight_Idle_dir5")
    },
    east = {
        filepath = "Assets/Character/Idle/Knight_Idle_dir6.png",
        animationData = require("Assets.Character.Idle.Knight_Idle_dir6")
    },
    southEast = {
        filepath = "Assets/Character/Idle/Knight_Idle_dir7.png",
        animationData = require("Assets.Character.Idle.Knight_Idle_dir7")
    },
    south = {
        filepath = "Assets/Character/Idle/Knight_Idle_dir8.png",
        animationData = require("Assets.Character.Idle.Knight_Idle_dir8")
    },
    southWest = {
        filepath = "Assets/Character/Idle/Knight_Idle_dir1.png",
        animationData = require("Assets.Character.Idle.Knight_Idle_dir1")
    },
    west = {
        filepath = "Assets/Character/Idle/Knight_Idle_dir2.png",
        animationData = require("Assets.Character.Idle.Knight_Idle_dir2")
    },
    northWest = {
        filepath = "Assets/Character/Idle/Knight_Idle_dir3.png",
        animationData = require("Assets.Character.Idle.Knight_Idle_dir3")
    }
}
local directions = {
    north = {
        filepath = "Assets/Character/Run/Knight_Run_dir4.png",
        animationData = require("Assets.Character.Run.Knight_Run_dir4")
    },
    northEast = {
        filepath = "Assets/Character/Run/Knight_Run_dir5.png",
        animationData = require("Assets.Character.Run.Knight_Run_dir5")
    },
    east = {
        filepath = "Assets/Character/Run/Knight_Run_dir6.png",
        animationData = require("Assets.Character.Run.Knight_Run_dir6")
    },
    southEast = {
        filepath = "Assets/Character/Run/Knight_Run_dir7.png",
        animationData = require("Assets.Character.Run.Knight_Run_dir7")
    },
    south = {
        filepath = "Assets/Character/Run/Knight_Run_dir8.png",
        animationData = require("Assets.Character.Run.Knight_Run_dir8")
    },
    southWest = {
        filepath = "Assets/Character/Run/Knight_Run_dir1.png",
        animationData = require("Assets.Character.Run.Knight_Run_dir1")
    },
    west = {
        filepath = "Assets/Character/Run/Knight_Run_dir2.png",
        animationData = require("Assets.Character.Run.Knight_Run_dir2")
    },
    northWest = {
        filepath = "Assets/Character/Run/Knight_Run_dir3.png",
        animationData = require("Assets.Character.Run.Knight_Run_dir3")
    }
}


function loadAnimation(direction)
    -- Vider les anciens quads
    quads = {}

    -- Charger la spritesheet
    if not directions[direction] then
        error("Direction invalide : " .. tostring(direction))
    end
    local collection 
    if moved then
        collection = directions
    else
        collection = idles
    end

    spriteSheet = love.graphics.newImage(collection[direction].filepath)
    local animData = collection[direction].animationData

    -- Créer les quads pour chaque frame de la direction choisie
    for i, frameData in ipairs(animData.frames) do
        local f = frameData.frame
        local quad = love.graphics.newQuad(f.x, f.y, f.w, f.h, spriteSheet:getDimensions())
        table.insert(quads, {
            quad = quad,
            duration = frameData.duration / 1000  -- convertir ms en secondes
        })
    end
end

function love.load()
    tilemap = generator.generateMap(mapSize)
    camera.x = ((mapSize - mapSize) * (tileWidth / 2))
    camera.y = ((mapSize + mapSize) * (tileHeight / 2)) / 2

    loadAnimation(currentDirection)
end

function isoToTile(iso_x, iso_y)
    local col = (iso_x / (tileWidth / 2) + iso_y / (tileHeight / 2)) / 2
    local row = (iso_y / (tileHeight / 2) - iso_x / (tileWidth / 2)) / 2
    return col, row
end

local speed = 200

function love.update(dt)
    local previousDirection = currentDirection
    local previousMoved = moved
    -- Distance à déplacer par frame
    local moveX, moveY = 0, 0
    local moveX, moveY = 0, 0
    local stepX, stepY = 3, 3 -- adapte ta vitesse ici

    
    local right = love.keyboard.isDown("right")
    local left = love.keyboard.isDown("left")
    local up = love.keyboard.isDown("up")
    local down = love.keyboard.isDown("down")
    
    -- Compter combien de touches directionnelles sont appuyées
    local count = (right and 1 or 0) + (left and 1 or 0) + (up and 1 or 0) + (down and 1 or 0)
    if count > 0 then
        moved = true
        if count == 1 then
            -- Une seule touche appuyée
            if right then
                currentDirection = "east"
                moveX = moveX + stepX / 2

            elseif left then
                currentDirection = "west"
                moveX = moveX - stepX / 2

            elseif up then
                currentDirection = "north"
                moveY = moveY - stepY / 2
            elseif down then
                currentDirection = "south"
                moveY = moveY + stepY / 2
            end
            moved = true
        elseif count == 2 then
            -- Deux touches appuyées : gérer les diagonales
            if right and down then
                currentDirection = "southEast"
                moveX = moveX
                moveY = moveY
                moveX = moveX + stepX / 2
                moveY = moveY + stepY / 2
            elseif right and up then
                currentDirection = "northEast"
                moveX = moveX + stepX / 2
                moveY = moveY - stepY / 2
            elseif left and down then
                currentDirection = "southWest"
                moveX = moveX - stepX / 2
                moveY = moveY + stepY / 2
            elseif left and up then
                currentDirection = "northWest"
                moveX = moveX - stepX / 2
                moveY = moveY - stepY / 2
            end
            moved = true
        end
    else
            
            moved = false
    end
    
    camera.x = camera.x + moveX
    camera.y = camera.y + moveY

    -- Reload animation if direction changed
    if previousDirection ~= currentDirection or previousMoved ~= moved then
        loadAnimation(currentDirection)
        currentFrame = 1
        timer = 0
    end

    -- Animation frame update
    if #quads == 0 then return end

    timer = timer + dt
    if timer >= quads[currentFrame].duration then
        timer = timer - quads[currentFrame].duration
        currentFrame = currentFrame + 1
        if currentFrame > #quads then
            currentFrame = 1
        end
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

end

local function drawChar()
    if #quads == 0 then return end

    local quad = quads[currentFrame].quad

    -- Centre l'animation au milieu de l'écran
    local x = love.graphics.getWidth() / 2
    local y = love.graphics.getHeight() / 2

    -- Dessine en centrant le sprite
    love.graphics.draw(spriteSheet, quad, x, y, 0, 1, 1, 128, 128) -- 128 = centre (256/2)
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
