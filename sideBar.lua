local sideBar = {
    setCursorAction = {}
}
local x, y = 10, 10
local menuWidth, menuHeight = 80, 350
local lineWidth = 2
local space = 2
local function bgDraw()
    --fond
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", x, y, menuWidth, menuHeight, 7, 7, 3)
    --contour
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(lineWidth)
    love.graphics.rectangle("line", x, y, menuWidth, menuHeight, 7, 7, 3)
end

local function btnDraw(mouseX, mouseY)
    local buttonX = x + lineWidth + (space * 2)
    local buttonY = y + lineWidth + (space * 2)
    local btnWidth = menuWidth - (lineWidth * 2) - (space * 2)
    local btnHeight = btnWidth - (space * 2)
    local hover = mouseX >= x and mouseX <= buttonX + btnWidth and
        mouseY >= buttonY and mouseY <= buttonY + btnHeight
    --fond
    if hover then
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    love.graphics.rectangle("fill", buttonX, buttonY, btnHeight,
        btnWidth, 7, 7, 3)
    --contour
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x + lineWidth + (space * 2), y + lineWidth + (space * 2), btnWidth - (space * 2),
        btnWidth, 7, 7, 3)
end

function sideBar.Load(setCursorAction)
    sideBar.setCursorAction = setCursorAction
end

function sideBar.Draw()
    local mouseX, mouseY = love.mouse.getPosition()
    --menu
    bgDraw()

    --boutons
    btnDraw(mouseX, mouseY)
end

function sideBar.Update()
    local mouseX, mouseY = love.mouse.getPosition()
    local mousePressed = love.mouse.isDown(1)
    local buttonX = x + lineWidth + (space * 2)
    local buttonY = y + lineWidth + (space * 2)
    local btnWidth = menuWidth - (lineWidth * 2) - (space * 2)
    local btnHeight = btnWidth - (space * 2)
    local hover = mouseX >= x and mouseX <= buttonX + btnWidth and
        mouseY >= buttonY and mouseY <= buttonY + btnHeight
    if hover and mousePressed then
        sideBar.setCursorAction(true)
    end
end

return sideBar
