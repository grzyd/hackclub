local map = {}
map.__index = map



function map.new(tile, layout)
    local self = {
        tileSize = tile,
        MapLayout = layout

    }
    setmetatable(self, map)
    return self
end

function map:load()
    self.grassImage = love.graphics.newImage("src/gfx/grass.png")
    self.grassQuad = love.graphics.newQuad(
        0, 0,
        self.tileSize, self.tileSize,
        self.grassImage:getDimensions()
    )
    self.pathImg = love.graphics.newImage("src/gfx/path.png")
    self.pathQuad = love.graphics.newQuad(
        0, 0,
        self.tileSize, self.tileSize,
        self.pathImg:getDimensions()
    )
end

function map:draw()
    for y, row in ipairs(self.MapLayout) do
        for x, tile in ipairs(row) do
            local groundType = math.floor(tile / 10)
            if groundType == 0 then
                groundType = tile
            end
            if groundType == 1 then
                love.graphics.setColor(0.6, 0.6, 0.4)
            elseif groundType == 2 then
                love.graphics.setColor(0.1, 0.1, 0.1)
            elseif groundType == 3 then
                love.graphics.setColor(1, 1, 1)

                love.graphics.draw(
                    self.grassImage,
                    self.grassQuad,
                    (x - 1) * self.tileSize,
                    (y - 1) * self.tileSize
                )
            elseif groundType == 4 then
                love.graphics.setColor(1, 1, 1)

                love.graphics.draw(
                    self.pathImg,
                    self.pathQuad,
                    (x - 1) * self.tileSize,
                    (y - 1) * self.tileSize
                )
            end
            if groundType ~= 3 and groundType ~= 4 then
                love.graphics.rectangle(
                    "fill",
                    (x - 1) * self.tileSize,
                    (y - 1) * self.tileSize,
                    self.tileSize,
                    self.tileSize
                )
            end
        end
    end

    love.graphics.setColor(1, 1, 1)
end

function map:hasLOS(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1

    local distance = math.sqrt(dx * dx + dy * dy)
    local steps = math.ceil(distance / (self.tileSize / 4))

    if steps == 0 then
        return true
    end

    for i = 0, steps do
        local t = i / steps

        local x = x1 + dx * t
        local y = y1 + dy * t

        if self:colides(x, y, 1, 1) then
            return false
        end
    end

    return true
end

function map:getEnemySpawns()
    local spawns = {}

    for y, row in ipairs(self.MapLayout) do
        for x, tile in ipairs(row) do
            local spawnTile = tile % 10

            if spawnTile == 1 and tile >= 10 then
                local spawnX = (x - 0.5) * self.tileSize
                local spawnY = (y - 0.5) * self.tileSize

                table.insert(spawns, { x = spawnX, y = spawnY })
            end
        end
    end
    return spawns
end

function map:colides(x, y, h, w)
    local left = math.floor((x - w / 2) / self.tileSize) + 1
    local right = math.floor((x + w / 2) / self.tileSize) + 1
    local top = math.floor((y - h / 2) / self.tileSize) + 1
    local bottom = math.floor((y + h / 2) / self.tileSize) + 1

    for row = top, bottom do
        for col = left, right do
            local tile = self.MapLayout[row] and self.MapLayout[row][col]
            if tile then
                local groundType = tile >= 10 and math.floor(tile / 10) or tile

                if groundType ~= 1 and groundType ~= 3 and groundType ~= 4 then
                    return true
                end
            end
        end
    end
    return false
end

return map
