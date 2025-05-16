local Player = {
    animations = {
        idles = {
            north = {
                filepath = "Assets/Character/Idle/Knight_Idle_dir4.png",
                animationData = require("Assets.Character.Idle.Knight_Idle_dir4")
            },
            northEast = {
                filepath = "Assets/Character/Idle/Knight_Idle_dir5.png",
                animationData = require("Assets.Character.Idle.Knight_Idle_dir5")
            },
            east = {
                filepath = "Assets/Character/Idle/Knight_Idle_dir6.png",
                animationData = require("Assets.Character.Idle.Knight_Idle_dir6")
            },
            southEast = {
                filepath = "Assets/Character/Idle/Knight_Idle_dir7.png",
                animationData = require("Assets.Character.Idle.Knight_Idle_dir7")
            },
            south = {
                filepath = "Assets/Character/Idle/Knight_Idle_dir8.png",
                animationData = require("Assets.Character.Idle.Knight_Idle_dir8")
            },
            southWest = {
                filepath = "Assets/Character/Idle/Knight_Idle_dir1.png",
                animationData = require("Assets.Character.Idle.Knight_Idle_dir1")
            },
            west = {
                filepath = "Assets/Character/Idle/Knight_Idle_dir2.png",
                animationData = require("Assets.Character.Idle.Knight_Idle_dir2")
            },
            northWest = {
                filepath = "Assets/Character/Idle/Knight_Idle_dir3.png",
                animationData = require("Assets.Character.Idle.Knight_Idle_dir3")
            }
        },
        directions = {
            north = {
                filepath = "Assets/Character/Run/Knight_Run_dir4.png",
                animationData = require("Assets.Character.Run.Knight_Run_dir4")
            },
            northEast = {
                filepath = "Assets/Character/Run/Knight_Run_dir5.png",
                animationData = require("Assets.Character.Run.Knight_Run_dir5")
            },
            east = {
                filepath = "Assets/Character/Run/Knight_Run_dir6.png",
                animationData = require("Assets.Character.Run.Knight_Run_dir6")
            },
            southEast = {
                filepath = "Assets/Character/Run/Knight_Run_dir7.png",
                animationData = require("Assets.Character.Run.Knight_Run_dir7")
            },
            south = {
                filepath = "Assets/Character/Run/Knight_Run_dir8.png",
                animationData = require("Assets.Character.Run.Knight_Run_dir8")
            },
            southWest = {
                filepath = "Assets/Character/Run/Knight_Run_dir1.png",
                animationData = require("Assets.Character.Run.Knight_Run_dir1")
            },
            west = {
                filepath = "Assets/Character/Run/Knight_Run_dir2.png",
                animationData = require("Assets.Character.Run.Knight_Run_dir2")
            },
            northWest = {
                filepath = "Assets/Character/Run/Knight_Run_dir3.png",
                animationData = require("Assets.Character.Run.Knight_Run_dir3")
            }
        }
    },
    quads = {},
    moved = false,
    previousMoved = false,
    direction = "south",
    previousDirection = "south",
    currentDirection = "south",
    spriteSheet = {},
    currentFrame = 1,
    timer = 0 
}

function Player.Load()
    Player.quads = {}
    local collection 
    if Player.moved then
        collection = Player.animations.directions
    else
        collection = Player.animations.idles
    end
    
    print(Player.currentDirection)
    Player.spriteSheet = love.graphics.newImage(collection[Player.direction].filepath)
    local animData = collection[Player.direction].animationData
    for i, frameData in ipairs(animData.frames) do
        local f = frameData.frame
        local quad = love.graphics.newQuad(f.x, f.y, f.w, f.h, Player.spriteSheet:getDimensions())
        table.insert(Player.quads, {
            quad = quad,
            duration = frameData.duration / 1000  -- convertir ms en secondes
        })
    end
end

function Player.Update(dt)
    Player.previousDirection = Player.currentDirection
    -- Reload animation if direction changed
    if Player.previousDirection ~= Player.currentDirection or Player.previousMoved ~= Player.moved then
        Player.Load()
        Player.currentFrame = 1
        Player.timer = 0
    end

    -- Animation frame update
    if #Player.quads == 0 then return end

    Player.timer = Player.timer + dt
    if Player.timer >= Player.quads[Player.currentFrame].duration then
        Player.timer = Player.timer - Player.quads[Player.currentFrame].duration
        Player.currentFrame = Player.currentFrame + 1
        if Player.currentFrame > #Player.quads then
            Player.currentFrame = 1
        end
    end
end

function Player.Draw()
    if #Player.quads == 0 then return end

    local quad = Player.quads[Player.currentFrame].quad

    -- Centre l'animation au milieu de l'écran
    local x = love.graphics.getWidth() / 2
    local y = love.graphics.getHeight() / 2

    -- Dessine en centrant le sprite
    love.graphics.draw(Player.spriteSheet, quad, x, y, 0, 1, 1, 128, 128) -- 128 = centre (256/2)
end

return Player