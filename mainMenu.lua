local button = require("button")
local titleFont
local MainMenu = {
    goTo = {},
    buttons = {
        { text = "Play",    hovered = false },
        { text = "Options", hovered = false },
        { text = "Quit",    hovered = false }
    },
    inputCooldown = 0
}

function MainMenu.Load(goTo)
    MainMenu.goTo = goTo
    titleFont = love.graphics.newFont("Assets/Fonts/font.otf", 36)
    titleFont:setFilter("nearest", "nearest")
    button.Load()
end

function MainMenu.Update(dt)
    button.Update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    local mousePressed = love.mouse.isDown(1)

    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local menu_width = 220
    local button_height = 50
    local spacing = 50
    local num_buttons = #MainMenu.buttons
    local menu_height = num_buttons * button_height + (num_buttons - 1) * spacing
    local x = (window_width - menu_width) / 2
    local y_start = (window_height - menu_height) / 2 + 50

    for index, buttonData in ipairs(MainMenu.buttons) do
        local y = y_start + (index - 1) * (button_height + spacing)
        buttonData.hovered = false

        if
            mouseX >= x and mouseX <= x + menu_width and
            mouseY >= y and mouseY <= y + button_height
        then
            buttonData.hovered = true

            if mousePressed and not MainMenu.mouseWasPressed then
                MainMenu.goTo(buttonData.text)
            end
        end
    end
end

function MainMenu.Draw()
    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local menu_width = 220
    local button_height = 50
    local spacing = 50
    local num_buttons = #MainMenu.buttons
    local menu_height = num_buttons * button_height + (num_buttons - 1) * spacing

    local x = (window_width - menu_width) / 2
    local y_start = (window_height - menu_height) / 2 + 50

    --draw Title
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(titleFont)
    love.graphics.printf("Femur", 0, 100, love.graphics.getWidth(), "center")

    --draw buttons
    for index, value in ipairs(MainMenu.buttons) do
        local y = y_start + (index - 1) * (button_height + spacing)
        local isHovered = value.hovered
        button.Draw(x, y, menu_width, button_height, isHovered, value.text)
    end
end

return MainMenu
