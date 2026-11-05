local map = {}
map.__index = map


function map.new(tile) 
    local self = {
    tileSize = tile,
    MapLayout = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
}

}
    setmetatable(self, map)
    return self
end


function map:draw()
    for y, row in ipairs(self.MapLayout) do
        for x, tile in ipairs(row) do

            if tile == 1 then
                love.graphics.setColor(0.3, 0.3, 0.3)
            elseif tile == 2 then
                love.graphics.setColor(0.1, 0.1, 0.1)
            end

            love.graphics.rectangle(
                "fill",
                (x - 1) * self.tileSize,
                (y - 1) * self.tileSize,
                self.tileSize,
                self.tileSize
            )
        end
    end

    love.graphics.setColor(1, 1, 1)
end

function map:colides(x, y, h , w)
    local left = math.floor((x-w/2)/self.tileSize) + 1
    local right = math.floor((x+w/2)/self.tileSize) + 1
    local top = math.floor((y-h/2)/self.tileSize) + 1
    local bottom = math.floor((y+h/2)/self.tileSize)+ 1

    for row=top, bottom do
        for col = left, right do
            local tile = self.MapLayout[row] and self.MapLayout[row][col]
            if tile ~= 1 then
                return true
            end
        end
    end
    return false
end

return map