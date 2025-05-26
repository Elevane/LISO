local titleFont
local Button = {
    timer = 0,
    floatSpeed = 4,
    floatHeight = 5
}

function Button.Load()
    titleFont = love.graphics.newFont("Assets/Fonts/font.otf", 24)
    titleFont:setFilter("nearest", "nearest")
end

function Button.Update(dt)
    Button.timer = Button.timer + dt
end

function Button.Draw(x, y, width, height, selected, text)
    local floatY = y

    if selected then
        local floatY = (y + math.sin(Button.timer * Button.floatSpeed) * Button.floatHeight) + height / 4
        love.graphics.setColor(0.2, 0.2, 0.2) -- gris foncé sinon
        -- Contour gris
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", x, floatY, width, height, 7, 7, 3)
    end
    -- Texte centré
    love.graphics.setColor(1, 1, 1)
    local textHeight = titleFont:getHeight()
    love.graphics.printf(text, x, floatY + (height - textHeight) / 2, width, "center")
end

return Button
