local suit = require 'suit'
local font = love.graphics.newFont("Assets/Fonts/font.otf", 36)
local MainMenu = {
    pixelTheme = {
        font = font,
        color = {
            normal  = { bg = { 0.2, 0.2, 0.2 }, fg = { 1, 1, 1 } },
            hovered = { bg = { 0.3, 0.3, 0.3 }, fg = { 1, 1, 0 } },
            active  = { bg = { 0.1, 0.1, 0.1 }, fg = { 1, 0, 0 } }
        },
        -- Dessin de bouton sans arrondi
        draw = {
            ['button'] = function(info, x, y, w, h)
                local c = info.color
                love.graphics.setColor(c.bg)
                love.graphics.rectangle("fill", x, y, w, h) -- pas d'arrondi

                love.graphics.setColor(0, 0, 0)             -- contour noir
                love.graphics.setLineStyle("rough")         -- bord pixelisé
                love.graphics.setLineWidth(1)
                love.graphics.rectangle("line", x, y, w, h)
                love.graphics.setColor(c.fg)
                love.graphics.setFont(font)
                love.graphics.printf(info.text, x, y + (h - font:getHeight()) / 2, w, "center")
            end
        }
    }
}
local message = ""

function MainMenu.Load()
    message = ""
    suit.theme = MainMenu.pixelTheme
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function MainMenu.Update(goTo)
    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local menu_width = 200
    local button_height = 40
    local spacing = 10
    local num_buttons = 2
    local menu_height = num_buttons * button_height + (num_buttons - 1) * spacing

    local x = (window_width - menu_width) / 2
    local y = (window_height - menu_height) / 2 + 50

    suit.layout:reset(x, y)

    if suit.Button("Jouer", suit.layout:row(menu_width, button_height)).hit then
        message = "Chargement du jeu..."
        goTo()
    end

    if suit.Button("Quitter", suit.layout:row()).hit then
        love.event.quit()
    end
end

function MainMenu.Draw()
    suit.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(MainMenu.font)
    love.graphics.printf("Femur", 0, 100, love.graphics.getWidth(), "center")

    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.printf(message, 0, love.graphics.getHeight() - 40, love.graphics.getWidth(), "center")
end

return MainMenu
