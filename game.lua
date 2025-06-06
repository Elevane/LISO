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
