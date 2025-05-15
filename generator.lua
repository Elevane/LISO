
local generator = {}

function generator.generateMap(size)
    local damier = {}
    for y = 1, size do
        damier[y] = {}
        for x = 1, size do
            local valeur = (x + y) % 2
            damier[y][x] = valeur
        end
    end
    return damier
end


return generator
