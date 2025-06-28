local mainMenu = require("mainMenu")
local game = require("game")
local screen = "main"
local cursorImage

local function goTo(screenName)
    if screenName == "Play" then
        screen = "game"
        game.Load()
    elseif screenName == "Quit" then
        love.event.quit()
    end
end

function love.load()
    --love.mouse.setVisible(false) -- Hide the default mouse cursor
    --cursorImage = love.graphics.newImage("Assets/cursor.png")
    if screen == "main" then
        mainMenu.Load(goTo)
    elseif screen == "game" then
        game.Load()
    end
end

function love.wheelmoved(x, y)
    if screen == "game" then
        game.wheelMoved(x, y)
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
    --local mouseX, mouseY = love.mouse.getPosition()
    -- Optionally offset to center the image
    --local cursorWidth = cursorImage:getWidth()
    --local cursorHeight = cursorImage:getHeight()
    --love.graphics.draw(cursorImage, mouseX - cursorWidth / 2, mouseY - cursorHeight / 2)
    if screen == "main" then
        mainMenu.Draw()
    elseif screen == "game" then
        game.Draw()
    end
end
