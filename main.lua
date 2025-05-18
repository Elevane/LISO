
local player = require("player")
local camera = require("camera")


function love.load() 
    player.Load()
end

function love.update(dt)
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
                player.direction = "east"
                camera.moveEast()
            elseif left then
                player.direction = "west"
                camera.moveWest()
            elseif up then
                player.direction = "north"
                camera.moveNorth()
            elseif down then
                player.direction = "south"
                camera.moveSouth()
            end
        elseif numberOfKeysPressed == 2 then
            -- Deux touches appuyées : gérer les diagonales
            if right and down then
                player.direction = "southEast"
                camera.moveSouthEast()
            elseif right and up then
                player.direction = "northEast"
                camera.moveNorthEast()
            elseif left and down then
                player.direction = "southWest"
                camera.moveSouthWest()
            elseif left and up then
                player.direction = "northWest"
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


function love.draw()
    camera.Draw()
    player.Draw()
end
