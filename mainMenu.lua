local suit = require 'suit'
local titleFont
local MainMenu = {}
function MainMenu.Load()
    titleFont = love.graphics.newFont("Assets/Fonts/font.otf", 36)
    titleFont:setFilter("nearest", "nearest")
end

function MainMenu.Update(goTo)
    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local menu_width = 220
    local button_height = 50
    local spacing = 10
    local num_buttons = 2
    local menu_height = num_buttons * button_height + (num_buttons - 1) * spacing

    local x = (window_width - menu_width) / 2
    local y = (window_height - menu_height) / 2 + 50

    suit.layout:reset(x, y)

    if suit.Button("Jouer", suit.layout:row(menu_width, button_height)).hit then
        goTo()
    end
    suit.layout:row(spacing, spacing)
    if suit.Button("Quitter", suit.layout:row(menu_width, button_height)).hit then
        love.event.quit()
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

function MainMenu.Draw()
    suit.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(titleFont)
    love.graphics.printf("Femur", 0, 100, love.graphics.getWidth(), "center")
end

return MainMenu
