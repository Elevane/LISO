local mainMenu = require("mainMenu")
local game = require("game")
local screen = "main"
local screens = {
    { name = "main", title = "Main Menu" },
    { name = "game", title = "Game" },
}

local function goTo()
    screen = "game"
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
        mainMenu.Update(goTo)
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
