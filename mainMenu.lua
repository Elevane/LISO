local button = require("button")
local titleFont
local MainMenu = {
    selected = 1,
    buttons = {
        { text = "Play" },
        { text = "Options" },
        { text = "Quit" }
    },
    inputCooldown = 0
}

function MainMenu.Load()
    titleFont = love.graphics.newFont("Assets/Fonts/font.otf", 36)
    titleFont:setFilter("nearest", "nearest")
    button.Load()
end

function MainMenu.Update(dt, goTo)
    button.Update(dt)

    -- Met à jour le cooldown
    if MainMenu.inputCooldown > 0 then
        MainMenu.inputCooldown = MainMenu.inputCooldown - dt
    end

    if MainMenu.inputCooldown <= 0 then
        if love.keyboard.isDown("down") then
            MainMenu.selected = (MainMenu.selected % #MainMenu.buttons) + 1
            MainMenu.inputCooldown = 0.2 -- 200ms de délai
        elseif love.keyboard.isDown("up") then
            MainMenu.selected = (MainMenu.selected - 2 + #MainMenu.buttons) % #MainMenu.buttons + 1
            MainMenu.inputCooldown = 0.2
        elseif love.keyboard.isDown("return") then
            goTo(MainMenu.buttons[MainMenu.selected].text)
        elseif love.keyboard.isDown("escape") then
            love.event.quit()
        end
    end
end

function MainMenu.Draw()
    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local menu_width = 220
    local button_height = 50
    local spacing = 50
    local num_buttons = 2
    local menu_height = num_buttons * button_height + (num_buttons - 1) * spacing

    local x = (window_width - menu_width) / 2
    local y_start = (window_height - menu_height) / 2 + 50
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(titleFont)
    love.graphics.printf("Femur", 0, 100, love.graphics.getWidth(), "center")

    for index, value in ipairs(MainMenu.buttons) do
        local y = y_start + index * (button_height + spacing)
        local isSelected = (index == MainMenu.selected)
        button.Draw(x, y, menu_width, button_height, isSelected, value.text)
    end
end

return MainMenu
