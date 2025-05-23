local player = require("player")
local camera = require("camera")
local generator = require("generator")

local tilemap = generator.generateMap()
local game = {}

function game.Load()
    player.Load()
    camera.Load(tilemap)
end

function game.Draw()
    camera.Draw()
    player.Draw()
end

function game.Update()
    local right = love.keyboard.isDown("right")
    local left = love.keyboard.isDown("left")
    local up = love.keyboard.isDown("up")
    local down = love.keyboard.isDown("down")

    camera.PreUpdate()
    local numberOfKeysPressed = (right and 1 or 0) + (left and 1 or 0) + (up and 1 or 0) + (down and 1 or 0)
    if numberOfKeysPressed > 0 then
        player.moved = true
        if numberOfKeysPressed == 1 then
            if right then
                player.currentDirection = "east"
                camera.moveEast()
            elseif left then
                player.currentDirection = "west"
                camera.moveWest()
            elseif up then
                player.currentDirection = "north"
                camera.moveNorth()
            elseif down then
                player.currentDirection = "south"
                camera.moveSouth()
            end
        elseif numberOfKeysPressed == 2 then
            -- Deux touches appuyées : gérer les diagonales
            if right and down then
                player.currentDirection = "southEast"
                camera.moveSouthEast()
            elseif right and up then
                player.currentDirection = "northEast"
                camera.moveNorthEast()
            elseif left and down then
                player.currentDirection = "southWest"
                camera.moveSouthWest()
            elseif left and up then
                player.currentDirection = "northWest"
                camera.moveNorthWest()
            end
        end
        camera.Update()
    else
        player.moved = false
    end


    player.Update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

return game
