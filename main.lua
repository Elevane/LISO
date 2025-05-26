local mainMenu = require("mainMenu")
local game = require("game")
local screen = "main"

local function goTo(screenName)
    if screenName == "Play" then
        screen = "game"
    elseif screenName == "Quit" then
        love.event.quit()
    end
end

function love.load()
    if screen == "main" then
        mainMenu.Load()
    elseif screen == "game" then
        game.Load()
    end
end

function love.update(dt)
    if screen == "main" then
        mainMenu.Update(dt, goTo)
    elseif screen == "game" then
        game.Update(dt)
    end
end

function love.draw()
    if screen == "main" then
        mainMenu.Draw()
    elseif screen == "game" then
        game.Draw()
    end
end
