local generator = {}

function generator.generateMap()
    -- local damier = {}
    -- for y = 1, size do
    --     damier[y] = {}
    --     for x = 1, size do
    --         local valeur = (x + y) % 2
    --         damier[y][x] = valeur
    --     end
    -- end
    return generateChunkyMap(20, 40, 12)
end

function generateChunkyMap(rows, cols, numChunks)
    rows = rows or 20
    cols = cols or 40
    numChunks = numChunks or 10

    local map = {}
    for r = 1, rows do
        map[r] = {}
        for c = 1, cols do
            map[r][c] = 0
        end
    end

    for _ = 1, numChunks do
        local chunkWidth = math.random(3, 8)
        local chunkHeight = math.random(3, 6)
        local startRow = math.random(1, rows - chunkHeight)
        local startCol = math.random(1, cols - chunkWidth)

        for r = startRow, startRow + chunkHeight do
            for c = startCol, startCol + chunkWidth do
                map[r][c] = 1
            end
        end
    end

    return map
end

return generator
