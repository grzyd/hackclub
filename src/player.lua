local Player = {}
Player.__index = Player

function Player.new(x, y, map)
    local self = {
        x = (x - 0.5) * map.tileSize,
        y = (y - 0.5) * map.tileSize,
        speed = 200,
        angle = 0,
        width = 40,
        height = 40,
        damage = 20,
        fireRate = 2,
        fireTimer = 0,
        health = 100,
        maxHealth = 100

    }
    setmetatable(self, Player)
    return self
end

function Player:update(dt, gameMap)
    local dx = 0
    local dy = 0

    if love.keyboard.isDown("w") then dy = dy - 1 end
    if love.keyboard.isDown("s") then dy = dy + 1 end
    if love.keyboard.isDown("a") then dx = dx - 1 end
    if love.keyboard.isDown("d") then dx = dx + 1 end




    local length = math.sqrt(dx * dx + dy * dy)

    if length > 0 then
        dx = dx / length
        dy = dy / length
    end
    local moveX = dx * self.speed * dt
    local moveY = dy * self.speed * dt
    if not gameMap:colides(self.x + moveX, self.y, self.height, self.width) then
        self.x = self.x + moveX
    end
    if not gameMap:colides(self.x, self.y + moveY, self.height, self.width) then
        self.y = self.y + moveY
    end

    


    local mx, my = love.mouse.getPosition()

    self.angle = math.atan2(
        my - self.y,
        mx - self.x
    )
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    self.x = math.max(self.width / 2, math.min(self.x, width - self.width / 2))
    self.y = math.max(self.height / 2, math.min(self.y, height - self.height / 2))
end

function Player:draw()
    love.graphics.push()
    love.graphics.setColor(1, 1, 1)
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.angle)
    love.graphics.rectangle("fill", -20, -20, self.width, self.height)
    love.graphics.pop()
end

function Player:drawHealtBar()
    local barWidth = 200
    local barHeight = 20

    local x = 30
    local y = 30

    local healthProcentage = self.health/self.maxHealth


    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", x, y, barWidth, barHeight)

    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.rectangle("fill", x, y, barWidth*healthProcentage, barHeight)

    love.graphics.setColor(1,1,1)

end


return Player
