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
    sideBar.Update()
    camera.PreUpdate()
    local numberOfKeysPressed = (right and 1 or 0) + (left and 1 or 0) + (up and 1 or 0) + (down and 1 or 0)
    if numberOfKeysPressed > 0 then
        if numberOfKeysPressed == 1 then
            if right then
                camera.moveEast()
            elseif left then
                camera.moveWest()
            elseif up then
                camera.moveNorth()
            elseif down then
                camera.moveSouth()
            end
        elseif numberOfKeysPressed == 2 then
            -- Deux touches appuyées : gérer les diagonales
            if right and down then
                camera.moveSouthEast()
            elseif right and up then
                camera.moveNorthEast()
            elseif left and down then
                camera.moveSouthWest()
            elseif left and up then
                camera.moveNorthWest()
            end
        end
    end
    camera.Update()


    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

return game
