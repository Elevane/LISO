local camera = require("camera")
local generator = require("generator")
local sideBar = require("sideBar")
local tilemap = generator.generateMap()
local game = {
    hasAction = false
}
local function setCursorAction(hasAction)
    game.hasAction = hasAction
end
function game.Load()
    camera.Load(tilemap)
    sideBar.Load(setCursorAction)
end

function game.Draw()
    camera.Draw()
    sideBar.Draw()
    if game.hasAction then
        local mouseX, mouseY = love.mouse.getPosition()
        love.graphics.setColor(1, 0, 01)
        love.graphics.rectangle("line", mouseX - 100, mouseY - 100, 100,
            100, 7, 7, 3)
    end
end

function game.wheelMoved(x, y)
    if y == 0 then return end

    local old_scale = camera.scale or 1.0
    local new_scale = old_scale + y * 0.1
    new_scale = math.max(0.5, math.min(3, new_scale))

    if new_scale == old_scale then return end

    -- Position de la souris
    local mouseX, mouseY = love.mouse.getPosition()

    -- Convertir la position écran -> monde (avant le zoom)
    local worldX_before = (mouseX - camera.width / 2) / old_scale + camera.x
    local worldY_before = mouseY / old_scale + camera.y

    -- Appliquer le nouveau zoom
    camera.scale = new_scale

    -- Nouvelle position monde du curseur (après zoom)
    local worldX_after = (mouseX - camera.width / 2) / new_scale + camera.x
    local worldY_after = mouseY / new_scale + camera.y

    -- Décalage à appliquer à la caméra pour que le point sous la souris reste fixe
    camera.x = camera.x + (worldX_before - worldX_after)
    camera.y = camera.y + (worldY_before - worldY_after)
end

function game.Update()
    local right = love.keyboard.isDown("right")
    local left = love.keyboard.isDown("left")
    local up = love.keyboard.isDown("up")
    local down = love.keyboard.isDown("down")
    local mouseX, mouseY = love.mouse.getPosition()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    local edgeThreshold = 20 -- pixels depuis le bord

    -- Contrôle souris dans les bords
    local mouseRight = mouseX >= windowWidth - edgeThreshold
    local mouseLeft = mouseX <= edgeThreshold
    local mouseUp = mouseY <= edgeThreshold
    local mouseDown = mouseY >= windowHeight - edgeThreshold

    -- Fusion clavier + souris
    local moveRight = right or mouseRight
    local moveLeft = left or mouseLeft
    local moveUp = up or mouseUp
    local moveDown = down or mouseDown

    sideBar.Update()
    camera.PreUpdate()

    -- Gestion diagonales + directions simples
    if moveRight and moveDown then
        camera.moveSouthEast()
    elseif moveRight and moveUp then
        camera.moveNorthEast()
    elseif moveLeft and moveDown then
        camera.moveSouthWest()
    elseif moveLeft and moveUp then
        camera.moveNorthWest()
    elseif moveRight then
        camera.moveEast()
    elseif moveLeft then
        camera.moveWest()
    elseif moveUp then
        camera.moveNorth()
    elseif moveDown then
        camera.moveSouth()
    end

    camera.Update()

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

return game
