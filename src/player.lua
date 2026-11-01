local Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = {
        x = x,
        y = y,
        speed = 200,
        angle = 0,
        width = 40,
        height = 40
        
    }    
    setmetatable(self, Player)
    return self
end





function Player:update(dt)
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

    self.x = self.x + dx * self.speed * dt
    self.y = self.y + dy * self.speed * dt


    local mx, my = love.mouse.getPosition()

    self.angle = math.atan2(
        my - self.y,
        mx - self.x
    )
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    self.x = math.max(self.width/2, math.min(self.x, width-self.width/2))
    self.y = math.max(self.height/2, math.min(self.y, height-self.height/2))
end

function Player:draw()
    love.graphics.push()

    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.angle)
    love.graphics.rectangle("fill", -20, -20, self.width, self.height)
    love.graphics.pop()
end


return Player